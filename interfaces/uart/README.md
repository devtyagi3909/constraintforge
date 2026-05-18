# UART Constraints

UART is asynchronous — constraints use `set_false_path`, not `set_input_delay`.

## Files

| File | Description |
|------|-------------|
| [`uart.xdc`](uart.xdc) | Vivado — false path, pin location, IOSTANDARD |
| [`uart.sdc`](uart.sdc) | Quartus — false path |
| [`uart.lpf`](uart.lpf) | nextpnr — pin location only, no timing directive |

---

← [Back to main README](../../README.md)
