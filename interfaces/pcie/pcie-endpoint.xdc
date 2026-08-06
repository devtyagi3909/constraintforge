# ---
# PCIe Endpoint Constraints — Xilinx Vivado (.xdc)
# ---

# 1. PCIe Reference Clock (100 MHz)
# This clock comes from the motherboard slot or external oscillator.
# It is routed directly to the gigabit transceiver (GT) reference clock inputs.
create_clock -period 10.000 -name pcie_sys_clk [get_ports pcie_clk_p]

# Clock location (Replace <GT_REFCLK_PIN> with your board's pin)
set_property PACKAGE_PIN <GT_REFCLK_PIN> [get_ports pcie_clk_p]

# 2. PCIe System Reset (PERST#)
# Active-low reset from the host system.
set_property PACKAGE_PIN <PERST_PIN> [get_ports pcie_perst_n]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_perst_n]

# PERST# is asynchronous to the application logic. Tell Vivado not to time it.
set_false_path -from [get_ports pcie_perst_n]

# 3. Transceiver Location Constraints
# The PCIe IP requires the GT lanes to be locked to specific physical quads.
# (Example for a 4-lane Gen3 endpoint)
set_property LOC <GT_CHANNEL_0_LOC> [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]
set_property LOC <GT_CHANNEL_1_LOC> [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST}]
set_property LOC <GT_CHANNEL_2_LOC> [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe4_channel_inst[2].GTHE4_CHANNEL_PRIM_INST}]
set_property LOC <GT_CHANNEL_3_LOC> [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST}]

# 4. Clock Domain Crossing (CDC)
# The PCIe IP generates a `user_clk` (e.g., 250 MHz for Gen3 x4, 256-bit).
# If your application logic runs on a different clock (e.g., sys_clk), 
# you MUST declare them asynchronous to prevent unresolvable timing errors.
set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks pcie_sys_clk] \
    -group [get_clocks -include_generated_clocks sys_clk]
