# AXI4-Lite Constraints

AXI4-Lite is the ARM AMBA standard control bus used by virtually every Xilinx IP core. It is fully synchronous — no source-synchronous clocking.

## Files

| File | Description |
|------|-------------|
| [`axi4-lite.xdc`](axi4-lite.xdc) | Vivado — clock, reset false path, multi-clock CDC, multicycle patterns |
| [`axi4-lite.sdc`](axi4-lite.sdc) | Quartus — same approach |

## Key Concept

For AXI4-Lite signals **internal to the FPGA** (between IPs in Block Design), Vivado handles timing automatically once the clock is defined. You only need explicit constraints for:
- `axi_aresetn` (async reset → `set_false_path`)
- CDC between different AXI clock domains
- Custom multicycle paths in your AXI slave logic

---

← [Back to main README](../../README.md)
