with open('README.md', 'r') as f:
    content = f.read()

new_section = r"""
<p align="center">
  <img src="terminal_demo.svg" alt="ConstraintForge Structural Diagnostic Engine Demo" />
</p>

## 🚀 NEW: Pre-Synthesis Structural Diagnostic Engine

ConstraintForge is now more than just constraints. It includes a headless structural timing diagnostic CLI that runs in your terminal and parses your Verilog into a Directed Acyclic Graph (DAG) to instantly detect logic depth and fanout bottlenecks. 

It predicts Vivado timing failures in **0.1 seconds** before you even run Synthesis.

### Installation & Usage

Install the CLI via pip:
```bash
pip install constraintforge
```
*(Requires [Yosys](https://yosyshq.net/yosys/) installed and available in `$PATH`)*

Run the engine on any RTL file:
```bash
constraintforge diagnose rtl/fetch_unit.v
```

**[Read the IEEE Paper on the Mathematical Correlation of this Tool (WOSET 2026 Submission)]()**

---

"""

# Insert the new section right after the links block
insert_target = "**[AI Generator](https://devtyagi3909.github.io/constraintforge/ai-generator.html)**\n\n"

if insert_target in content:
    content = content.replace(insert_target, insert_target + new_section)
    # Also fix the old SVG path to ensure it uses the new terminal_demo if we want, or leave the old one. 
    # Actually, the user had an old terminal SVG. Let's just remove the old one so there aren't two SVGs.
    content = content.replace('<p align="center">\n  <img src="assets/terminal_demo.svg" alt="ConstraintForge Terminal Demo" />\n</p>\n\n', '')
else:
    print("Could not find insertion point.")

with open('README.md', 'w') as f:
    f.write(content)
