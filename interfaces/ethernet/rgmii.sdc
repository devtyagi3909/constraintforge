# ---
# RGMII ETHERNET CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
# RGMII is DDR source-synchronous. See interfaces/ethernet/rgmii.xdc for theory.
# ---

set_time_format -unit ns -decimal_places 3

# Primary clocks — define before PLL derivation
create_clock -name {sys_clk}    -period 20.000 [get_ports {clk}]
create_clock -name {eth_rxclk}  -period  8.000 [get_ports {eth_rxclk}]

derive_pll_clocks
derive_clock_uncertainty


# ---
# TX Output Delays (DDR — both edges of GTXCLK)
# ---
set_output_delay -clock {eth_gtxclk} -max  1.000 [get_ports {eth_txd[*]}]
set_output_delay -clock {eth_gtxclk} -min -1.000 [get_ports {eth_txd[*]}]
set_output_delay -clock {eth_gtxclk} -max  1.000 [get_ports {eth_txctl}]
set_output_delay -clock {eth_gtxclk} -min -1.000 [get_ports {eth_txctl}]

set_output_delay -clock {eth_gtxclk} -max  1.000 -fall [get_ports {eth_txd[*]}]
set_output_delay -clock {eth_gtxclk} -min -1.000 -fall [get_ports {eth_txd[*]}]
set_output_delay -clock {eth_gtxclk} -max  1.000 -fall [get_ports {eth_txctl}]
set_output_delay -clock {eth_gtxclk} -min -1.000 -fall [get_ports {eth_txctl}]


# ---
# RX Input Delays (DDR — both edges of RXCLK)
# ---
set_input_delay -clock {eth_rxclk} -max  1.500 [get_ports {eth_rxd[*]}]
set_input_delay -clock {eth_rxclk} -min  1.000 [get_ports {eth_rxd[*]}]
set_input_delay -clock {eth_rxclk} -max  1.500 [get_ports {eth_rxctl}]
set_input_delay -clock {eth_rxclk} -min  1.000 [get_ports {eth_rxctl}]

set_input_delay -clock {eth_rxclk} -max  1.500 -fall [get_ports {eth_rxd[*]}]
set_input_delay -clock {eth_rxclk} -min  1.000 -fall [get_ports {eth_rxd[*]}]
set_input_delay -clock {eth_rxclk} -max  1.500 -fall [get_ports {eth_rxctl}]
set_input_delay -clock {eth_rxclk} -min  1.000 -fall [get_ports {eth_rxctl}]


# ---
# Async false paths and CDC
# ---
set_false_path -to   [get_ports {eth_mdc}]
set_false_path -from [get_ports {eth_mdio}]
set_false_path -to   [get_ports {eth_mdio}]
set_false_path -to   [get_ports {eth_rst_n}]

set_clock_groups -asynchronous \
    -group [get_clocks {eth_rxclk}] \
    -group [get_clocks {sys_clk}]
