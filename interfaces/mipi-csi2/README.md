# MIPI CSI-2 RX Constraints

MIPI CSI-2 is the standard camera interface for image sensors. Every AI vision project in 2024–2026 uses CSI-2 (OV5640, IMX219, IMX477, AR1335, and more).

## Files

| File | Description |
|------|-------------|
| [`mipi-csi2-rx.xdc`](mipi-csi2-rx.xdc) | Vivado — D-PHY clock, LVDS pairs, I2C control, CDC |
| [`mipi-csi2-rx.sdc`](mipi-csi2-rx.sdc) | Quartus — CDC and control signal false paths |

## Strong Recommendation

For production designs, use **Xilinx MIPI CSI-2 RX Subsystem IP (PG232)** — it generates all timing constraints automatically and handles D-PHY lane training.

This manual template is for educational use and 7-Series devices where the full IP is not available.

---

← [Back to main README](../../README.md)
