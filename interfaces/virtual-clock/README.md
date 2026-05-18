# Virtual Clock Constraints

A virtual clock is a clock used in timing analysis that has **no physical pin** on the FPGA. It models external clocks that drive peripherals on the PCB but don't enter the FPGA.

## Files

| File | Description |
|------|-------------|
| [`virtual-clock.xdc`](virtual-clock.xdc) | Vivado — 5 patterns with full theory and explanations |
| [`virtual-clock.sdc`](virtual-clock.sdc) | Quartus — same syntax |

## When Do You Need This?

When you write `set_input_delay -clock X` and clock X **doesn't physically enter the FPGA through a constrained port**, you need a virtual clock. Common cases:
- Shared board oscillator drives both FPGA and a peripheral
- ADC/DAC clocked from the same PCB oscillator as your FPGA
- Output register external to FPGA clocked by board oscillator

## The One-Line Summary

`create_clock -period 10.0 -name virt_clk` — no `[get_ports]` = virtual clock.

---

← [Back to main README](../../README.md)
