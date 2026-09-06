with open('README.md', 'r') as f:
    content = f.read()

# Replace my static image with their original animated SVG in the new section, or put it back at the top.
# Let's just put their original animated SVG back at the very top.
old_static = r"""<p align="center">
  <img src="terminal_demo.svg" alt="ConstraintForge Structural Diagnostic Engine Demo" />
</p>

## 🚀 NEW: Pre-Synthesis Structural Diagnostic Engine"""

new_animated = r"""<p align="center">
  <img src="assets/terminal_demo.svg" alt="ConstraintForge Terminal Demo" />
</p>

## 🚀 NEW: Pre-Synthesis Structural Diagnostic Engine"""

content = content.replace(old_static, new_animated)

with open('README.md', 'w') as f:
    f.write(content)
