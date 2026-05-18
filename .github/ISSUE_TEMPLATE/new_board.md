---
name: New Board Request / Submission
about: Add a board that isn't in the library yet — or request one
title: "[BOARD] <Board Name> — <Vendor>"
labels: new-board
assignees: ''
---

## Board Details

**Board name:** 
**Vendor:** (e.g. Digilent, Terasic, Lattice, Radiona, OSHPark)
**FPGA device (full part number):** (e.g. XC7A100T-1CSG324C)
**FPGA family:** (e.g. Artix-7, Cyclone V, ECP5, iCE40)
**Constraint format needed:** (XDC / QSF+SDC / LPF)

---

## Are you submitting a file or requesting one?

- [ ] I am submitting a constraint file (please attach or paste below)
- [ ] I am requesting someone else add this board

---

## If submitting — verification checklist

Before submitting a board constraint file, confirm:

- [ ] Pin assignments verified against the **official board schematic** (not just a tutorial)
- [ ] IOSTANDARD matches the **bank VCCO voltage** (e.g. 3.3V → LVCMOS33)
- [ ] Clock constraint included with correct frequency and `create_clock`
- [ ] Async signals (buttons, UART, resets) have `set_false_path`
- [ ] `CFGBVS` and `CONFIG_VOLTAGE` set (Xilinx only)
- [ ] Tested: file loads without DRC errors in the target toolchain

---

## Reference links

**Board schematic URL:** 
**Reference manual URL:** 
**Vendor master XDC/QSF URL (if exists):** 

---

## Paste constraint file or describe what's needed

```tcl
# paste your .xdc / .qsf / .lpf here, or describe the board
```
