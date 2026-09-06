import json
from collections import defaultdict
import sys

def build_and_analyze(json_file):
    with open(json_file, 'r') as f:
        data = json.load(f)
    
    modules = data.get("modules", {})
    if not modules:
        return
    
    top_module = list(modules.keys())[0] # Just grab the first for now
    mod = modules[top_module]
    
    ports = mod.get("ports", {})
    cells = mod.get("cells", {})
    
    bit_driver = {}
    sources = set()
    sinks = set()
    nodes = set()
    comb_cells = set()
    
    # Identify ports
    for port_name, port_data in ports.items():
        direction = port_data["direction"]
        node_name = f"port:{port_name}"
        nodes.add(node_name)
        if direction == "input" or direction == "inout":
            sources.add(node_name)
            for bit in port_data["bits"]:
                if isinstance(bit, int):
                    bit_driver[bit] = node_name
        if direction == "output" or direction == "inout":
            sinks.add(node_name)
            
    # Identify cells and their drivers
    for cell_name, cell_data in cells.items():
        cell_type = cell_data["type"].lower()
        is_seq = "dff" in cell_type or "latch" in cell_type
        
        if is_seq:
            for port, bits in cell_data.get("connections", {}).items():
                dir = cell_data["port_directions"].get(port, "input")
                if dir == "output":
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
        if direction == "output" or direction == "inout":
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
                if dir == "input":
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

    # Topological DFS with memoization
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
                continue
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
    
    print(f"Sources: {sources}")
    print(f"Sinks: {sinks}")
    print(f"Bit drivers: {bit_driver}")
    print(f"Adjacency list: {dict(adj)}")
    
    for src in sources:
        depth, path = dfs(src, set())
        if depth > global_max:
            global_max = depth
            global_path = path
            
    print(f"Max depth: {global_max}")
    print(f"Path: {global_path}")

if __name__ == '__main__':
    build_and_analyze(sys.argv[1])
