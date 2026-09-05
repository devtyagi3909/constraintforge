import svgwrite

def create_terminal_svg(filename="terminal_demo.svg"):
    dwg = svgwrite.Drawing(filename, size=(800, 420))
    
    # Background
    dwg.add(dwg.rect(insert=(0, 0), size=('100%', '100%'), rx=8, ry=8, fill='#0d1117'))
    
    # Mac window controls
    dwg.add(dwg.circle(center=(20, 20), r=6, fill='#ff5f56'))
    dwg.add(dwg.circle(center=(40, 20), r=6, fill='#ffbd2e'))
    dwg.add(dwg.circle(center=(60, 20), r=6, fill='#27c93f'))
    
    # Header text
    dwg.add(dwg.text("devtyagi@macbook: ~/constraintforge", insert=(400, 24), 
                     text_anchor="middle", fill="#8b949e", font_family="monospace", font_size="14px"))
    
    # Separator
    dwg.add(dwg.line(start=(0, 40), end=(800, 40), stroke="#30363d", stroke_width=1))
    
    # Content
    y = 70
    line_height = 24
    
    lines = [
        [("#27c93f", "➜ "), ("#3b8eea", "~ "), ("#ff7b72", "constraintforge "), ("#c9d1d9", "diagnose rtl/fetch_unit.v")],
        [("#8b949e", "")],
        [("#c9d1d9", "[*] Parsing Verilog AST via headless Yosys...")],
        [("#c9d1d9", "[*] Extracting Directed Acyclic Graph (DAG)...")],
        [("#c9d1d9", "[*] Executing Topological DFS Memoization...")],
        [("#8b949e", "")],
        [("#ff7b72", "## DIAGNOSTIC REPORT: fetch_unit.v ##")],
        [("#8b949e", "")],
        [("#ffa657", "[WARNING] setup-time risk detected:")],
        [("#c9d1d9", "  Source:    pc_reg_reg[0]/C")],
        [("#c9d1d9", "  Sink:      issue_queue_inst/din_reg[31]/D")],
        [("#ff7b72", "  Logic Depth: 28 gates")],
        [("#8b949e", "")],
        [("#27c93f", "[OK] Fanout Analysis:")],
        [("#c9d1d9", "  Zero registers exceeded the 100-endpoint high-fanout threshold.")],
        [("#c9d1d9", "  Maximum detected fanout: 14 (branch_predictor_enable_reg)")],
    ]
    
    for line in lines:
        if not line:
            y += line_height
            continue
            
        x = 20
        text_elem = dwg.text("", insert=(x, y), font_family="Menlo, Monaco, Consolas, monospace", font_size="14px")
        
        for color, text in line:
            tspan = svgwrite.text.TSpan(text, fill=color)
            text_elem.add(tspan)
            
        dwg.add(text_elem)
        y += line_height

    dwg.save()

if __name__ == "__main__":
    create_terminal_svg("/Users/devtyagi/Downloads/constraintforge/terminal_demo.svg")
