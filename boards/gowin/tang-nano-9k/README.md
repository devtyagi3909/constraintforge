# Tang Nano 9K

**Device:** GW1NR-LV9QN88PC6/I5 (Gowin GW1NR-9C) | **Vendor:** Sipeed

**Format:** `.cst` (pin constraints) + `.sdc` (timing) — Gowin EDA format.

**Covered:** 27 MHz clock, 6 LEDs (active low), 2 buttons, USB-UART (BL616), HDMI (LVCMOS33D differential), on-package HyperRAM, SPI Flash, GPIO header.

**Toolchain options:**
- Gowin EDA (official, free): https://www.gowinsemi.com/en/support/download_eda/
- OSS CAD Suite (open-source): openFPGALoader + apicula

```bash
# Program with openFPGALoader:
openFPGALoader -b tangnano9k --write-sram design.fs
```

> This is the **first comprehensive open-source constraint template for the Tang Nano 9K**. The Gowin toolchain documentation for constraints is sparse — this file fills that gap.

---

← [Back to main README](../../../README.md)
