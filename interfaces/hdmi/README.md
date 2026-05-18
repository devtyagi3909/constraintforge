# HDMI / TMDS Constraints

HDMI uses TMDS with embedded clock recovery. Output timing uses `set_false_path` — the receiver reconstructs timing from the TMDS clock channel.

## Files

| File | Description |
|------|-------------|
| [`hdmi.xdc`](hdmi.xdc) | Vivado — pixel clock MMCM, TMDS_33 standard, false path on outputs |
| [`hdmi.sdc`](hdmi.sdc) | Quartus — PLL derivation, false path on TMDS ports |

---

← [Back to main README](../../README.md)
