import json
import sys

with open(sys.argv[1], 'r') as f:
    data = json.load(f)

mod = list(data["modules"].values())[0]
for cname, cdata in mod["cells"].items():
    if cdata["type"] == "$mem_v2":
        print(cname)
        print(cdata["port_directions"])
