# LVDS Constraints

LVDS is source-synchronous differential signaling. The source clock travels alongside data.

## Files

| File | Description |
|------|-------------|
| [`lvds.xdc`](lvds.xdc) | Vivado — create_clock on incoming LVDS clock, set_input_delay, DIFF_TERM |
| [`lvds.sdc`](lvds.sdc) | Quartus — same approach with SDC syntax |
| [`lvds.lpf`](lvds.lpf) | nextpnr — LVDS25 IO_TYPE, FREQUENCY on clock port, optional TERMINATION |

---

← [Back to main README](../../README.md)
