import argparse
import subprocess
import json
import sys
import os
from collections import defaultdict

def run_yosys(file_paths, top_module):
    read_cmds = []
    for fp in file_paths:
        if fp.endswith('.sv'):
            read_cmds.append(f"read_verilog -sv {fp}")
        else:
            read_cmds.append(f"read_verilog {fp}")
    
    script = "; ".join(read_cmds)
    script += f"; prep -top {top_module}; flatten; opt; techmap; opt; write_json"
    
    cmd = ["yosys", "-p", script]
    try:
        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
        # Parse JSON output from stdout
        json_str = ""
        capture = False
        for line in result.stdout.splitlines():
            if line.strip() == "{":
                capture = True
            if capture:
                json_str += line + "\n"
                
        if not json_str:
            sys.stderr.write("Error: Yosys did not output valid JSON.\n")
            sys.exit(1)
            
        return json.loads(json_str)
    except subprocess.CalledProcessError as e:
        sys.stderr.write(f"Yosys failed:\n{e.stderr}\n")
        sys.exit(1)
    except json.JSONDecodeError as e:
        sys.stderr.write(f"Failed to parse Yosys JSON: {e}\n")
        sys.exit(1)

def diagnose_rtl(args):
    # Load exceptions if provided
    exceptions = {"false_paths": [], "cdc_safe": []}
    if args.exceptions and os.path.exists(args.exceptions):
        try:
            with open(args.exceptions, 'r') as f:
                exceptions = json.load(f)
        except Exception as e:
            sys.stderr.write(f"Failed to load exceptions: {e}\n")
            
    if not args.json and not args.sarif:
        print(f"[*] Parsing {', '.join(args.files)} AST via headless Yosys...")
        
    yosys_ast = run_yosys(args.files, args.top)
    
    if not args.json and not args.sarif:
        print("[*] Extracting Directed Acyclic Graph (DAG)...")
        
    modules = yosys_ast.get("modules", {})
    if not modules:
        sys.stderr.write("No modules found in AST.\n")
        sys.exit(1)
        
    top_mod = modules.get(args.top) or list(modules.values())[0]
    
    ports = top_mod.get("ports", {})
    cells = top_mod.get("cells", {})
    netnames = top_mod.get("netnames", {})
    
    bit_to_netname = {}
    for net, data in netnames.items():
        for bit in data.get("bits", []):
            if isinstance(bit, int):
                bit_to_netname[bit] = net

    nodes = set()
    sources = set()
    sinks = set()
    comb_cells = set()
    bit_driver = {}
    
    node_src = {}
    node_clk = {}
    
    # Identify ports as sources/sinks
    for port_name, port_data in ports.items():
        direction = port_data["direction"]
        node_name = f"port:{port_name}"
        nodes.add(node_name)
        node_src[node_name] = top_mod.get("attributes", {}).get("src", "unknown")
        
        if direction in ["input", "inout"]:
            sources.add(node_name)
            for bit in port_data["bits"]:
                if isinstance(bit, int):
                    bit_driver[bit] = node_name
        if direction in ["output", "inout"]:
            sinks.add(node_name)
            
    # Identify cells and their drivers
    for cell_name, cell_data in cells.items():
        cell_type = cell_data["type"].lower()
        is_seq = "dff" in cell_type or "latch" in cell_type or "mem" in cell_type
        
        src_attr = cell_data.get("attributes", {}).get("src", "unknown")
        
        if is_seq:
            clk_bit = None
            clk_port_name = None
            connections = cell_data.get("connections", {})
            for clk_port in ["CLK", "C", "RD_CLK", "WR_CLK", "EN", "ARST"]:
                if clk_port in connections:
                    bits = connections[clk_port]
                    if bits and isinstance(bits[0], int):
                        clk_bit = bits[0]
                        clk_port_name = clk_port
                        break
                        
            clk_net = bit_to_netname.get(clk_bit, f"bit_{clk_bit}") if clk_bit is not None else None
            
            for port, bits in connections.items():
                dir = cell_data["port_directions"].get(port, "input")
                if dir == "output":
                    node_name = f"cell:{cell_name}:{port}"
                    nodes.add(node_name)
                    sources.add(node_name)
                    node_src[node_name] = src_attr
                    node_clk[node_name] = clk_net
                    for bit in bits:
                        if isinstance(bit, int):
                            bit_driver[bit] = node_name
        else:
            node_name = f"cell:{cell_name}"
            nodes.add(node_name)
            comb_cells.add(node_name)
            node_src[node_name] = src_attr
            for port, bits in cell_data.get("connections", {}).items():
                dir = cell_data["port_directions"].get(port, "input")
                if dir == "output":
                    for bit in bits:
                        if isinstance(bit, int):
                            bit_driver[bit] = node_name
                            
    # Build adjacency list
    adj = defaultdict(list)
    bit_sinks = defaultdict(list)
    
    for port_name, port_data in ports.items():
        direction = port_data["direction"]
        if direction in ["output", "inout"]:
            node_name = f"port:{port_name}"
            for bit in port_data["bits"]:
                if isinstance(bit, int) and bit in bit_driver:
                    adj[bit_driver[bit]].append(node_name)
                    bit_sinks[bit].append(node_name)
                    
    for cell_name, cell_data in cells.items():
        cell_type = cell_data["type"].lower()
        is_seq = "dff" in cell_type or "latch" in cell_type or "mem" in cell_type
        
        if is_seq:
            clk_bit = None
            clk_port_name = None
            connections = cell_data.get("connections", {})
            for clk_port in ["CLK", "C", "RD_CLK", "WR_CLK", "EN", "ARST"]:
                if clk_port in connections:
                    bits = connections[clk_port]
                    if bits and isinstance(bits[0], int):
                        clk_bit = bits[0]
                        clk_port_name = clk_port
                        break
            clk_net = bit_to_netname.get(clk_bit, f"bit_{clk_bit}") if clk_bit is not None else None
            
            for port, bits in cell_data.get("connections", {}).items():
                dir = cell_data["port_directions"].get(port, "input")
                if dir == "input" and port != clk_port_name:
                    node_name = f"cell:{cell_name}:{port}"
                    nodes.add(node_name)
                    sinks.add(node_name)
                    node_src[node_name] = cell_data.get("attributes", {}).get("src", "unknown")
                    node_clk[node_name] = clk_net
                    for bit in bits:
                        if isinstance(bit, int) and bit in bit_driver:
                            adj[bit_driver[bit]].append(node_name)
                            bit_sinks[bit].append(node_name)
        else:
            node_name = f"cell:{cell_name}"
            for port, bits in cell_data.get("connections", {}).items():
                dir = cell_data["port_directions"].get(port, "input")
                if dir == "input":
                    for bit in bits:
                        if isinstance(bit, int) and bit in bit_driver:
                            adj[bit_driver[bit]].append(node_name)
                            bit_sinks[bit].append(node_name)
                            
    if not args.json and not args.sarif:
        print("[*] Executing Topological DFS Memoization...\n")
    
    memo = {}
    comb_loops = set()
    visiting = set()
    
    def get_weight(u):
        return 1 if u in comb_cells else 0
        
    def dfs(u):
        if u in visiting:
            comb_loops.add(u)
            return (-1, []) # cycle
        if u in memo:
            return memo[u]
            
        visiting.add(u)
        max_child_depth = -1
        best_child_path = []
        
        for v in adj[u]:
            depth, path = dfs(v)
            if depth > max_child_depth:
                max_child_depth = depth
                best_child_path = path
                
        visiting.remove(u)
        
        if max_child_depth >= 0:
            memo[u] = (get_weight(u) + max_child_depth, [u] + best_child_path)
        else:
            memo[u] = (get_weight(u), [u])
            
        return memo[u]
        
    global_max = -1
    global_path = []
    all_paths = []
    
    for src in sources:
        depth, path = dfs(src)
        if depth >= 0:
            all_paths.append((depth, path))
        if depth > global_max:
            global_max = depth
            global_path = path
            
    exit_code = 0
    results = {
        "loops": [],
        "fanout": [],
        "setup_violations": [],
        "cdc_violations": []
    }
    
    if comb_loops:
        exit_code = 1
        for loop_node in list(comb_loops):
            results["loops"].append({"node": loop_node, "src": node_src.get(loop_node, 'unknown')})
        
    # Check for High Fanout
    for bit, children in bit_sinks.items():
        fanout = len(set(children))
        if fanout > args.fanout_threshold:
            u = bit_driver.get(bit, "unknown")
            net_name = bit_to_netname.get(bit, f"bit_{bit}")
            results["fanout"].append({
                "net": net_name,
                "driver": u,
                "src": node_src.get(u, 'unknown'),
                "count": fanout
            })
            exit_code = 1
            
    # Check Paths for Setup and CDC
    for depth, path in sorted(all_paths, reverse=True):
        if len(path) < 2:
            continue
            
        source_node = path[0]
        sink_node = path[-1]
        source_clk = node_clk.get(source_node)
        sink_clk = node_clk.get(sink_node)
        
        # Check exceptions
        src_file_line = node_src.get(source_node, "unknown")
        sink_file_line = node_src.get(sink_node, "unknown")
        
        is_false_path = any(fp.get("from") in src_file_line and fp.get("to") in sink_file_line for fp in exceptions.get("false_paths", []))
        is_cdc_safe = any(cp.get("from") == source_clk and cp.get("to") == sink_clk for cp in exceptions.get("cdc_safe", []))
        
        if not is_false_path and depth > args.depth_threshold:
            if not results["setup_violations"]: # Just capture the worst for now
                results["setup_violations"].append({
                    "source": source_node, "source_src": src_file_line, "source_clk": source_clk,
                    "sink": sink_node, "sink_src": sink_file_line, "sink_clk": sink_clk,
                    "depth": depth,
                    "trace": [ {"node": n, "src": node_src.get(n, "unknown")} for n in path ] if args.explain else []
                })
                exit_code = 1
                
        if source_clk and sink_clk and source_clk != sink_clk and not is_cdc_safe:
            # Only record unique CDC crossings
            existing = [c for c in results["cdc_violations"] if c["source_clk"] == source_clk and c["sink_clk"] == sink_clk]
            if not existing:
                results["cdc_violations"].append({
                    "source": source_node, "source_src": src_file_line, "source_clk": source_clk,
                    "sink": sink_node, "sink_src": sink_file_line, "sink_clk": sink_clk
                })
                exit_code = 1

    # Output generation
    if args.json:
        print(json.dumps(results, indent=2))
    elif args.sarif:
        # Minimal SARIF generation for GitHub Code Scanning
        sarif = {
            "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
            "version": "2.1.0",
            "runs": [{
                "tool": {
                    "driver": {
                        "name": "ConstraintForge",
                        "informationUri": "https://devtyagi3909.github.io/constraintforge",
                        "rules": [
                            {"id": "CF001", "name": "LogicDepth", "shortDescription": {"text": "Logic depth exceeds threshold"}},
                            {"id": "CF002", "name": "CDC", "shortDescription": {"text": "Unsynchronized Clock Domain Crossing"}},
                            {"id": "CF003", "name": "HighFanout", "shortDescription": {"text": "Net fanout exceeds threshold"}}
                        ]
                    }
                },
                "results": []
            }]
        }
        for sv in results["setup_violations"]:
            sarif["runs"][0]["results"].append({
                "ruleId": "CF001",
                "message": {"text": f"Logic depth of {sv['depth']} exceeds threshold of {args.depth_threshold}."},
                "locations": [{"physicalLocation": {"artifactLocation": {"uri": sv['source_src'].split(':')[0]}}}]
            })
        print(json.dumps(sarif, indent=2))
    else:
        print(f"## DIAGNOSTIC REPORT: {', '.join(args.files)} ##\n")
        if results["loops"]:
            print("[WARNING] Combinational loop(s) detected during DFS!")
            for l in results["loops"][:5]:
                print(f"  Loop at: {l['node']} ({l['src']})")
            print()
            
        if results["fanout"]:
            print(f"[WARNING] High-fanout nets (>{args.fanout_threshold}) detected:")
            for f in results["fanout"][:5]:
                print(f"  Net: {f['net']} (Driver: {f['driver']} [{f['src']}]) -> Fanout: {f['count']}")
            print()
            
        if results["setup_violations"]:
            v = results["setup_violations"][0]
            print(f"[WARNING] Setup-time risk detected (> {args.depth_threshold} gates):")
            print(f"  Source:      {v['source']} ({v['source_src']}) [Clk: {v['source_clk']}]")
            print(f"  Sink:        {v['sink']} ({v['sink_src']}) [Clk: {v['sink_clk']}]")
            print(f"  Logic Depth: {v['depth']} gates")
            if args.explain and v['trace']:
                print("  Path Trace:")
                for step in v['trace']:
                    print(f"    -> {step['node']} ({step['src']})")
            print()
            
        if results["cdc_violations"]:
            for c in results["cdc_violations"]:
                print(f"[!] CDC ALERT: Unsynchronized crossing from {c['source_clk']} to {c['sink_clk']}!")
                print(f"    Path: {c['source_src']} -> {c['sink_src']}")
            print()
            
        if exit_code == 0:
            print("[OK] No structural violations detected.\n")

    sys.exit(exit_code)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="ConstraintForge Pre-Synthesis Structural Diagnostic Engine")
    parser.add_argument("files", nargs='+', help="Path to RTL file(s)")
    parser.add_argument("--top", required=True, help="Top module name")
    
    # New CLI features
    parser.add_argument("--depth-threshold", type=int, default=30, help="Maximum allowable logic depth (gates)")
    parser.add_argument("--fanout-threshold", type=int, default=100, help="Maximum allowable fanout per net")
    parser.add_argument("--exceptions", type=str, help="JSON file containing false_paths and cdc_safe exceptions")
    parser.add_argument("--explain", action="store_true", help="Print the full node-by-node path trace for violations")
    
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--json", action="store_true", help="Output results in JSON format")
    group.add_argument("--sarif", action="store_true", help="Output results in SARIF format for GitHub Code Scanning")
    
    args = parser.parse_args()
    diagnose_rtl(args)
