# Contributing

Thanks for helping. Every board file, every fixed comment, every new interface makes this more useful for everyone who lands here at midnight debugging timing violations.

---

## What's most useful

**In rough order of impact:**

1. **Board files you own** — the fastest PR to write and the most immediately useful. If you have a board not in `boards/`, a single `.xdc` with correct pin assignments is a great contribution.

2. **Correcting wrong pin numbers or IOSTANDARD values** — if something's wrong, open an issue with the board schematic page number or a link. Wrong constraints are worse than no constraints.

3. **Missing vendor coverage** — if an interface only has `.xdc` and you use Quartus, adding the `.sdc` is straightforward.

4. **Better annotations** — found a comment that's confusing, incomplete, or just wrong? Fix it. Comments are first-class content here.

---

## Adding a board

1. Create a folder: `boards/<vendor>/<board-name>/`
   - Use lowercase hyphenated names: `arty-a7-35t`, `tang-nano-20k`
   - Vendor folders: `xilinx`, `intel`, `lattice`, `gowin`

2. Copy the nearest existing board as a starting point

3. **Source of truth for pins** (in order of reliability):
   - The board's official schematic
   - The vendor's own master XDC/QSF file
   - The board's reference manual pin table

4. File header — keep it short:
   ```tcl
   # Board: <Name>
   # Device: <full part number>
   # Doc: <link to schematic or reference manual>
   ```

5. Before submitting, check:
   - PACKAGE_PIN values match the schematic
   - IOSTANDARD matches the bank's VCCO voltage
   - Clock has a `create_clock` with the right frequency
   - Async signals (buttons, UART, resets) have `set_false_path`
   - Xilinx boards have `CFGBVS` and `CONFIG_VOLTAGE` at the bottom

6. Add a short `README.md` in the same folder (device, what's covered, any gotchas)

---

## Adding an interface

Files go in `interfaces/<type>/`. Name them `<type>.xdc`, `<type>-<variant>.xdc` etc.

What a good interface file needs:
- A brief explanation of the timing model (what makes this interface different from a simple register output?)
- The formula for deriving constraint values from datasheet parameters
- Placeholder values using `<PIN_NAME>` format for things the user must fill in
- At the bottom: what to look for in your peripheral's datasheet, and what to change

Don't over-comment. If the timing model needs three paragraphs to explain, write three paragraphs. If a line is obvious (`set_false_path -from [get_ports uart_rxd]` needs at most one comment), don't pad it.

---

## PR process

1. Fork, branch off main: `git checkout -b add-ulx3s-85`
2. Add your files
3. Open a PR — CI runs XDC/SDC/LPF validation automatically
4. Describe what hardware you verified on (if any)

Board file PRs with correct schematics as source: merged within 24–48h.
Interface PRs: quick review on the timing model explanation.

---

## Reporting bugs

Use the bug report template. The key info: which file, which line, what the correct value is, and where you verified it (schematic page, datasheet section, tested on hardware).

---

## Questions

Open an issue with the `question` label. No question is too basic.
