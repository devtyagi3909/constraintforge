# DDR3 Constraints

**Use MIG (Xilinx) or EMIF (Intel) IP** — these generate all DDR3 constraints automatically. This template documents what they generate and what you must add alongside them.

## Files

| File | Description |
|------|-------------|
| [`ddr3.xdc`](ddr3.xdc) | Vivado — MIG reference clock, CDC to ui_clk, pin standards |
| [`ddr3.sdc`](ddr3.sdc) | Quartus — EMIF IP SDC inclusion, CDC, false paths |

---

← [Back to main README](../../README.md)
