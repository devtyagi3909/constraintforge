# I2C Constraints

I2C is open-drain and asynchronous. Use `set_false_path` on SCL and SDA.

## Files

| File | Description |
|------|-------------|
| [`i2c.xdc`](i2c.xdc) | Vivado — false path, open-drain DRIVE/SLEW settings |
| [`i2c.sdc`](i2c.sdc) | Quartus — false path |
| [`i2c.lpf`](i2c.lpf) | nextpnr — LVCMOS33, PULLMODE=UP for open-drain |

---

← [Back to main README](../../README.md)
