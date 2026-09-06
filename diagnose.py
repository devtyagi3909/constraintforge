#!/usr/bin/env python3
import sys
sys.setrecursionlimit(10000)
import subprocess
import json
import argparse
import os
from collections import defaultdict

def run_yosys(file_paths, top_module):
    print(f"[*] Parsing {file_paths} AST via headless Yosys...")
    yosys_cmd = [
        "yosys", "-q", "-p",
        f"prep -top {top_module}; flatten; opt; techmap; opt; write_json -"
    ] + file_paths
    try:
        res = subprocess.run(yosys_cmd, check=True, capture_output=True, text=True)
        return res.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running Yosys:\n{e.stderr}", file=sys.stderr)
        sys.exit(1)

def diagnose_rtl(file_paths, top_module):
    json_output = run_yosys(file_paths, top_module)
    
    print("[*] Extracting Directed Acyclic Graph (DAG)...")
    try:
        data = json.loads(json_output)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON from Yosys: {e}", file=sys.stderr)
        sys.exit(1)
        
    modules = data.get("modules", {})
    if top_module not in modules:
        print(f"Error: Top module {top_module} not found in Yosys output.", file=sys.stderr)
        sys.exit(1)
        
    mod = modules[top_module]
    
    ports = mod.get("ports", {})
    cells = mod.get("cells", {})
    
    bit_driver = {}
    sources = set()
    sinks = set()
    comb_cells = set()
    nodes = set()
    
    node_src = {}
    node_clk = {}
    
    # Map bit numbers to human-readable net names for CDC
    netnames = mod.get("netnames", {})
    bit_to_netname = {}
    for netname, net_data in netnames.items():
        if net_data.get("hide_name", 0) == 0:
            for bit in net_data["bits"]:
                if isinstance(bit, int):
                    bit_to_netname[bit] = netname

    # Identify ports
    for port_name, port_data in ports.items():
        direction = port_data["direction"]
        node_name = f"port:{port_name}"
        nodes.add(node_name)
        node_src[node_name] = mod.get("attributes", {}).get("src", "unknown")
        
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
            # Extract clock bit if any (usually 'CLK', 'C', 'EN')
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
    
    for src in sources:
        depth, path = dfs(src)
        if depth > global_max:
            global_max = depth
            global_path = path
            
    print(f"## DIAGNOSTIC REPORT: {', '.join(file_paths)} ##\n")
    
    if comb_loops:
        print("[WARNING] Combinational loop(s) detected during DFS!")
        for loop_node in list(comb_loops)[:5]:
            print(f"  Loop at: {loop_node} ({node_src.get(loop_node, 'unknown')})")
        print()
        
    # Check for High Fanout
    high_fanout_detected = False
    for bit, children in bit_sinks.items():
        fanout = len(set(children))
        if fanout > 100:
            if not high_fanout_detected:
                print("[WARNING] High-fanout nets (>100) detected:")
                high_fanout_detected = True
            u = bit_driver.get(bit, "unknown")
            net_name = bit_to_netname.get(bit, f"bit_{bit}")
            print(f"  Net: {net_name} (Driver: {u} [{node_src.get(u, 'unknown')}]) -> Fanout: {fanout}")
    if high_fanout_detected:
        print()
    
    if global_max >= 0 and len(global_path) >= 2:
        source_node = global_path[0]
        sink_node = global_path[-1]
        
        source_clk = node_clk.get(source_node)
        sink_clk = node_clk.get(sink_node)
        
        print("[WARNING] setup-time risk detected:")
        print(f"  Source:      {source_node} ({node_src.get(source_node, 'unknown')}) [Clk: {source_clk}]")
        print(f"  Sink:        {sink_node} ({node_src.get(sink_node, 'unknown')}) [Clk: {sink_clk}]")
        print(f"  Logic Depth: {global_max} gates")
        
        # CDC Warning
        if source_clk and sink_clk and source_clk != sink_clk:
            print(f"  [!] CDC ALERT: Clock domain crossing detected from {source_clk} to {sink_clk}!")
        print()
    else:
        print("[OK] No significant combinational path detected.\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="ConstraintForge Pre-Synthesis Structural Diagnostic Engine")
    parser.add_argument("files", nargs='+', help="Path to RTL file(s)")
    parser.add_argument("--top", required=True, help="Top module name")
    
    args = parser.parse_args()
    diagnose_rtl(args.files, args.top)
