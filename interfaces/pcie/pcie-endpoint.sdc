# ---
# PCIe Endpoint Constraints — Intel Quartus (.sdc)
# ---

# Set time format (Standard SDC requirement)
set_time_format -unit ns -decimal_places 3

# 1. PCIe Reference Clock (100 MHz)
create_clock -period 10.000 -name pcie_refclk [get_ports pcie_refclk_p]

# The Hard IP generates internal clocks. Let Quartus derive them automatically.
derive_pll_clocks
derive_clock_uncertainty

# 2. PCIe System Reset (PERST#)
# Asynchronous reset from the host.
set_false_path -from [get_ports pcie_perst_n]

# 3. Clock Domain Crossing (CDC)
# The Hard IP produces an `app_clk` or `core_clk`.
# If your application uses a separate `sys_clk`, declare them asynchronous.
set_clock_groups -asynchronous \
    -group [get_clocks pcie_refclk] \
    -group [get_clocks sys_clk]
