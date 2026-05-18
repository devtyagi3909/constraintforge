# I2S Audio Constraints

I2S (Inter-IC Sound) is the standard serial audio interface. Used in virtually every FPGA audio project — PYNQ-Z2, Zybo Z7, Nexys A7, DE1-SoC all have audio codecs using I2S.

## Files

| File | Description |
|------|-------------|
| [`i2s.xdc`](i2s.xdc) | Vivado — master and slave modes, BCLK generated clock, MCLK |
| [`i2s.sdc`](i2s.sdc) | Quartus — same approach |

## Key Concept

I2S has two operating modes:
- **FPGA as master** — FPGA generates BCLK and LRCLK → use `create_generated_clock` on the BCLK output port
- **FPGA as slave** — Codec drives BCLK/LRCLK → use `create_clock` on the BCLK input port

---

← [Back to main README](../../README.md)
