import subprocess
import tempfile
import os

from typing import Sequence, Optional

def generate_netlist(src_files: Sequence[str], top_module: str) -> Optional[str]:
    """Run Yosys in headless mode to generate a JSON netlist."""
    fd, json_path = tempfile.mkstemp(suffix=".json", prefix="cf_netlist_")
    os.close(fd)
    
    files_str = " ".join(src_files)
    
    yosys_script = f"""
    read_verilog -sv {files_str}
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
        if os.path.exists(json_path):
            os.remove(json_path)
        print(e.stderr.decode('utf-8'))
        return None
    except FileNotFoundError:
        if os.path.exists(json_path):
            os.remove(json_path)
        print("Error: 'yosys' executable not found in PATH.")
        return None
