# ULX3S (ECP5)

**Device:** LFE5U-85F-6BG381C (ECP5 85k) | **Vendor:** Radiona (open hardware)

**Covered:** 25 MHz clock, 8 LEDs, 7 buttons, 4 switches, USB-UART (FT231X), 32 MB SDRAM, HDMI GPDI (LVCMOS33D), WiFi/BT (ESP32), Pmod GP.

**Toolchain:** nextpnr-ecp5 + Yosys + prjtrellis

```bash
yosys -p 'synth_ecp5 -json design.json' design.v
nextpnr-ecp5 --85k --package CABGA381 --lpf ecp5.lpf --json design.json --textcfg out.config
ecppack out.config out.bit
```

---

← [Back to main README](../../../README.md)
