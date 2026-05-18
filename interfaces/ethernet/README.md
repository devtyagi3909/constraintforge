# Ethernet (RGMII) Constraints

RGMII is DDR source-synchronous at 125 MHz. Both rising and falling edges carry data.

## Files

| File | Description |
|------|-------------|
| [`rgmii.xdc`](rgmii.xdc) | Vivado — RX clock primary, TX generated clock, DDR delays, MDIO false path |
| [`rgmii.sdc`](rgmii.sdc) | Quartus — same approach |

---

← [Back to main README](../../README.md)
