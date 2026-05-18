# SPI Constraints

SPI is source-synchronous. Master and slave have different constraint approaches.

## Files

| File | Description |
|------|-------------|
| [`spi-master.xdc`](spi-master.xdc) | Vivado — generated clock on SCLK output, set_output/input_delay |
| [`spi-master.sdc`](spi-master.sdc) | Quartus — same approach |
| [`spi-master.lpf`](spi-master.lpf) | nextpnr — pin location, system clock FREQUENCY |
| [`spi-slave.xdc`](spi-slave.xdc) | Vivado — SCLK input as primary clock, CDC to sys_clk |
| [`spi-slave.sdc`](spi-slave.sdc) | Quartus — same approach |

---

← [Back to main README](../../README.md)
