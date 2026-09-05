import json
from collections import defaultdict

def build_graph(json_path):
    with open(json_path, 'r') as f:
        netlist = json.load(f)
        
    modules = netlist.get("modules", {})
    if not modules:
        return None
        
    top_mod = list(modules.keys())[0]
    cells = modules[top_mod].get("cells", {})
    ports = modules[top_mod].get("ports", {})
    
    bit_driver = {}
    cell_inputs = defaultdict(list)
    dff_cells = []
    
    for port_name, port_data in ports.items():
        if port_data["direction"] == "input":
            for b in port_data["bits"]:
                bit_driver[b] = f"PORT_IN:{port_name}"
    
    for cell_name, cell_data in cells.items():
        c_type = cell_data.get("type", "")
        if c_type.startswith("$_DFF_") or c_type.startswith("$dff"):
            dff_cells.append(cell_name)
            
        conns = cell_data.get("connections", {})
        dirs = cell_data.get("port_directions", {})
        
        for port_name, bits in conns.items():
            if dirs.get(port_name) == "output":
                for b in bits:
                    if isinstance(b, int):
                        bit_driver[b] = cell_name
            elif dirs.get(port_name) == "input":
                if (c_type.startswith("$_DFF_") or c_type.startswith("$dff")) and port_name in ["C", "CLK"]:
                    continue
                for b in bits:
                    if isinstance(b, int):
                        cell_inputs[cell_name].append(b)
                        
    return {
        "cells": cells,
        "ports": ports,
        "bit_driver": bit_driver,
        "cell_inputs": cell_inputs,
        "dff_cells": dff_cells
    }

def get_nice_name(cell_name, cells):
    if cell_name.startswith("PORT_"):
        return cell_name
    cell_data = cells.get(cell_name, {})
    src = cell_data.get("attributes", {}).get("src", "")
    if src:
        return f"{src.split()[0]} (Reg)"
    return cell_name

def analyze_logic_depth(graph, max_depth):
    bit_driver = graph["bit_driver"]
    cell_inputs = graph["cell_inputs"]
    cells = graph["cells"]
    
    depth_memo = {}
    
    def get_cell_depth(cell_name, visited):
        if cell_name in depth_memo:
            return depth_memo[cell_name]
            
        if cell_name in visited:
            return -99999, cell_name
            
        visited.add(cell_name)
        
        c_type = cells.get(cell_name, {}).get("type", "") if not cell_name.startswith("PORT_") else "PORT"
        
        if c_type.startswith("$_DFF_") or c_type.startswith("$dff") or c_type == "PORT":
            depth_memo[cell_name] = (0, cell_name)
            visited.remove(cell_name)
            return 0, cell_name
            
        max_in_depth = -99999
        src = cell_name
        
        for b in cell_inputs.get(cell_name, []):
            driver = bit_driver.get(b)
            if driver:
                d, s = get_cell_depth(driver, visited)
                if d > max_in_depth:
                    max_in_depth = d
                    src = s
                    
        # If no valid inputs were traced back to a DFF/PORT, it's driven by constants. Return negative.
        if max_in_depth < 0:
            my_depth = -99999
        else:
            my_depth = max_in_depth + 1
            
        depth_memo[cell_name] = (my_depth, src)
        visited.remove(cell_name)
        return my_depth, src

    results = []
    
    for dff in graph["dff_cells"]:
        max_d = -1
        src = ""
        for b in cell_inputs.get(dff, []):
            driver = bit_driver.get(b)
            if driver:
                d, s = get_cell_depth(driver, set())
                if d > max_d:
                    max_d = d
                    src = s
        if max_d >= max_depth:
            results.append({
                "source": get_nice_name(src, cells), 
                "sink": get_nice_name(dff, cells), 
                "depth": max_d
            })
            
    for port_name, port_data in graph["ports"].items():
        if port_data["direction"] == "output":
            max_d = -1
            src = ""
            for b in port_data["bits"]:
                driver = bit_driver.get(b)
                if driver:
                    d, s = get_cell_depth(driver, set())
                    if d > max_d:
                        max_d = d
                        src = s
            if max_d >= max_depth:
                results.append({
                    "source": get_nice_name(src, cells), 
                    "sink": f"PORT_OUT:{port_name}", 
                    "depth": max_d
                })
                
    results.sort(key=lambda x: x["depth"], reverse=True)
    
    seen = set()
    unique = []
    for r in results:
        key = (r["source"], r["sink"])
        if key not in seen:
            seen.add(key)
            unique.append(r)
            
    return unique[:10]

def analyze_fanout(graph, max_fanout):
    bit_driver = graph["bit_driver"]
    cell_inputs = graph["cell_inputs"]
    cells = graph["cells"]
    
    # Count how many cell inputs each bit feeds into
    bit_fanout = defaultdict(int)
    for cell_name, inputs in cell_inputs.items():
        for b in inputs:
            bit_fanout[b] += 1
            
    results = []
    
    # Check all DFF outputs
    for dff in graph["dff_cells"]:
        conns = cells[dff].get("connections", {})
        dirs = cells[dff].get("port_directions", {})
        for port_name, bits in conns.items():
            if dirs.get(port_name) == "output":
                for b in bits:
                    fanout = bit_fanout.get(b, 0)
                    if fanout >= max_fanout:
                        results.append({
                            "register": get_nice_name(dff, cells),
                            "fanout": fanout
                        })
                        
    results.sort(key=lambda x: x["fanout"], reverse=True)
    return results[:10]
