# ---
# MIPI CSI-2 RX CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
# For Intel FPGAs, MIPI CSI-2 is implemented via:
#   - Intel MIPI D-PHY IP (Arria 10, Stratix 10, Agilex)
#   - ALTLVDS_RX for older devices (Cyclone V, Arria V)
# The IP generates all timing constraints. This file covers the CDC and resets.
# See interfaces/mipi-csi2/mipi-csi2-rx.xdc for full theory.
# ---

set_time_format -unit ns -decimal_places 3

# System clock
create_clock -name {sys_clk} -period 10.000 [get_ports {clk}]

# MIPI byte clock (from D-PHY — if not using IP that auto-constrains)
# OV5640 example: 420 Mbps/lane → byte clock = 420/2/8 = 26.25 MHz... 
# Actually byte clock = lane_rate / 2 for DDR, so 420/2 = 210 MHz
# create_clock -name {mipi_byte_clk} -period 4.762 [get_ports {mipi_clk_p}]

derive_pll_clocks
derive_clock_uncertainty

# CDC: MIPI byte clock domain → system clock domain
# set_clock_groups -asynchronous \
#     -group [get_clocks {mipi_byte_clk}] \
#     -group [get_clocks {sys_clk}]

# Camera control signals — all async
set_false_path -to   [get_ports {cam_rst_n}]
set_false_path -to   [get_ports {cam_pwdn}]
set_false_path -from [get_ports {cam_scl}]
set_false_path -to   [get_ports {cam_scl}]
set_false_path -from [get_ports {cam_sda}]
set_false_path -to   [get_ports {cam_sda}]
