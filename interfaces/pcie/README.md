# PCIe Endpoint Constraints

This directory contains timing constraints for PCI Express (PCIe) Gen3/Gen4 Endpoint interfaces.

PCIe is a high-speed serial interface. The data paths are implemented using gigabit transceivers (GTs) and their internal logic is heavily constrained by vendor-provided IP (e.g., Xilinx PCIe PHY, Intel Hard IP for PCIe).

## What You Must Constrain
As a user, your primary responsibilities are:
1. Constrain the incoming 100 MHz reference clock (`PERST#` and `REFCLK`).
2. Define the clock domain crossings between the PCIe user clock (e.g., `user_clk`, `axi_aclk`) and your application logic.
3. Lock the GT transceivers to specific board locations.

## Included Files
* `pcie-endpoint.xdc`: Xilinx Vivado constraints (7-Series / UltraScale+)
* `pcie-endpoint.sdc`: Intel Quartus constraints (Cyclone V / Stratix 10)
