# Clock Constraints

Templates for primary clocks, generated clocks (MMCM/PLL), and clock uncertainty.

## Files

| File | Description |
|------|-------------|
| [`primary-clock.xdc`](primary-clock.xdc) | Vivado — single-ended and differential primary clocks |
| [`primary-clock.sdc`](primary-clock.sdc) | Quartus — with derive_pll_clocks and derive_clock_uncertainty |
| [`primary-clock.lpf`](primary-clock.lpf) | nextpnr — FREQUENCY directive for iCE40/ECP5 |
| [`generated-clock-mmcm.xdc`](generated-clock-mmcm.xdc) | Vivado — MMCM/PLL output generated clocks |
| [`generated-clock-mmcm.sdc`](generated-clock-mmcm.sdc) | Quartus — derive_pll_clocks usage |

---

← [Back to main README](../../README.md)
