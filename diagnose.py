#!/usr/bin/env python3
import sys
sys.setrecursionlimit(10000)
import subprocess
import json
import argparse
import os
import tempfile
from collections import defaultdict

def run_yosys(file_path, top_module, json_path):
    print(f"[*] Parsing {file_path} AST via headless Yosys...")
    yosys_cmd = [
        "yosys", "-p",
        f"prep -top {top_module}; flatten; opt; techmap; opt; write_json {json_path}",
        file_path
    ]
    try:
        subprocess.run(yosys_cmd, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running Yosys:\n{e.stderr}", file=sys.stderr)
        sys.exit(1)

def diagnose_rtl(file_path, top_module):
    with tempfile.TemporaryDirectory() as tmpdir:
        json_path = os.path.join(tmpdir, "netlist.json")
        run_yosys(file_path, top_module, json_path)
        
        print("[*] Extracting Directed Acyclic Graph (DAG)...")
        with open(json_path, 'r') as f:
            data = json.load(f)
            
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
        
        # Identify ports
        for port_name, port_data in ports.items():
            direction = port_data["direction"]
            node_name = f"port:{port_name}"
            nodes.add(node_name)
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
            is_seq = "dff" in cell_type or "latch" in cell_type
            
            if is_seq:
                for port, bits in cell_data.get("connections", {}).items():
                    dir = cell_data["port_directions"].get(port, "input")
                    if dir == "output" and port == "Q":
                        node_name = f"cell:{cell_name}:{port}"
                        nodes.add(node_name)
                        sources.add(node_name)
                        for bit in bits:
                            if isinstance(bit, int):
                                bit_driver[bit] = node_name
            else:
                node_name = f"cell:{cell_name}"
                nodes.add(node_name)
                comb_cells.add(node_name)
                for port, bits in cell_data.get("connections", {}).items():
                    dir = cell_data["port_directions"].get(port, "input")
                    if dir == "output":
                        for bit in bits:
                            if isinstance(bit, int):
                                bit_driver[bit] = node_name
                                
        # Build adjacency list
        adj = defaultdict(list)
        
        for port_name, port_data in ports.items():
            direction = port_data["direction"]
            if direction in ["output", "inout"]:
                node_name = f"port:{port_name}"
                for bit in port_data["bits"]:
                    if isinstance(bit, int) and bit in bit_driver:
                        adj[bit_driver[bit]].append(node_name)
                        
        for cell_name, cell_data in cells.items():
            cell_type = cell_data["type"].lower()
            is_seq = "dff" in cell_type or "latch" in cell_type
            
            if is_seq:
                for port, bits in cell_data.get("connections", {}).items():
                    dir = cell_data["port_directions"].get(port, "input")
                    if dir == "input" and port == "D":
                        node_name = f"cell:{cell_name}:{port}"
                        nodes.add(node_name)
                        sinks.add(node_name)
                        for bit in bits:
                            if isinstance(bit, int) and bit in bit_driver:
                                adj[bit_driver[bit]].append(node_name)
            else:
                node_name = f"cell:{cell_name}"
                for port, bits in cell_data.get("connections", {}).items():
                    dir = cell_data["port_directions"].get(port, "input")
                    if dir == "input":
                        for bit in bits:
                            if isinstance(bit, int) and bit in bit_driver:
                                adj[bit_driver[bit]].append(node_name)
                                
        print("[*] Executing Topological DFS Memoization...\n")
        
        memo = {}
        
        def get_weight(u):
            return 1 if u in comb_cells else 0
            
        def dfs(u, path_so_far):
            if u in memo:
                return memo[u]
                
            max_child_depth = -1
            best_child_path = []
            
            for v in adj[u]:
                if v in path_so_far:
                    continue # cycle
                depth, path = dfs(v, path_so_far | {u})
                if depth > max_child_depth:
                    max_child_depth = depth
                    best_child_path = path
                    
            if max_child_depth >= 0:
                memo[u] = (get_weight(u) + max_child_depth, [u] + best_child_path)
            else:
                memo[u] = (get_weight(u), [u])
                
            return memo[u]
            
        global_max = -1
        global_path = []
        
        for src in sources:
            depth, path = dfs(src, set())
            if depth > global_max:
                global_max = depth
                global_path = path
                
        print(f"## DIAGNOSTIC REPORT: {file_path} ##\n")
        
        if global_max >= 0 and len(global_path) >= 2:
            print("[WARNING] setup-time risk detected:")
            print(f"  Source:      {global_path[0]}")
            print(f"  Sink:        {global_path[-1]}")
            print(f"  Logic Depth: {global_max} gates\n")
        else:
            print("[OK] No significant combinational path detected.\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="ConstraintForge Pre-Synthesis Structural Diagnostic Engine")
    parser.add_argument("file", help="Path to RTL file")
    parser.add_argument("--top", required=True, help="Top module name")
    
    args = parser.parse_args()
    diagnose_rtl(args.file, args.top)
