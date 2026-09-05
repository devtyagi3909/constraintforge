import subprocess
import tempfile
import os

def generate_netlist(src_files, top_module):
    fd, json_path = tempfile.mkstemp(suffix=".json", prefix="cf_netlist_")
    os.close(fd)
    
    files_str = " ".join(src_files)
    
    yosys_script = f"""
    read_verilog {files_str}
    hierarchy -top {top_module}
    proc
    flatten
    techmap
    opt
    abc -g AND,OR,XOR
    opt
    write_json {json_path}
    """
    
    try:
        subprocess.run(
            ["yosys", "-p", yosys_script],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            check=True
        )
        return json_path
    except subprocess.CalledProcessError as e:
        print(e.stderr.decode('utf-8'))
        return None
