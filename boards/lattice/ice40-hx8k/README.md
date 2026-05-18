# iCE40-HX8K Breakout Board

**Device:** iCE40HX8K-CT256 | **Vendor:** Lattice Semiconductor

**Covered:** 12 MHz clock, 8 LEDs, 2 buttons, USB-UART (FTDI FT2232H), SPI Flash, Pmod J1/J2.

**Toolchain:** nextpnr-ice40 + Yosys (open-source) or iCEcube2 (Lattice)

```bash
nextpnr-ice40 --hx8k --package ct256 --lpf ice40-hx8k.lpf --json design.json --asc out.asc
icepack out.asc out.bin && iceprog out.bin
```

---

← [Back to main README](../../../README.md)
