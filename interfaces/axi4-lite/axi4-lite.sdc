# ---
# AXI4-LITE CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
# AXI4-Lite is fully synchronous — internal registered paths, no I/O delays.
# See interfaces/axi4-lite/axi4-lite.xdc for full theory.
# ---

set_time_format -unit ns -decimal_places 3

# AXI bus clock
create_clock -name {axi_aclk} -period 10.000 [get_ports {s_axi_aclk}]
derive_pll_clocks
derive_clock_uncertainty

# Async reset — always false path
set_false_path -from [get_ports {s_axi_aresetn}]

# Multi-clock AXI system CDC
# set_clock_groups -asynchronous \
#     -group [get_clocks {axi_aclk}] \
#     -group [get_clocks {axi_fast_clk}]

# Config register multicycle path (if needed)
# set_multicycle_path -setup 2 -from [get_registers {u_axi_slave:cfg_reg[*]}] -to [get_registers {u_axi_slave:decode_reg[*]}]
# set_multicycle_path -hold  1 -from [get_registers {u_axi_slave:cfg_reg[*]}] -to [get_registers {u_axi_slave:decode_reg[*]}]
