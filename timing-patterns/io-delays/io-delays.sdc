# ---
# I/O DELAY PATTERNS  —  Intel Quartus Prime (.sdc)
# ---
# See timing-patterns/io-delays/io-delays.xdc for full theory and derivation.
# ---

set_time_format -unit ns -decimal_places 3

# System-synchronous input
set_input_delay -clock {sys_clk} -max 7.000 [get_ports {adc_data[*]}]
set_input_delay -clock {sys_clk} -min 2.000 [get_ports {adc_data[*]}]

# System-synchronous output
set_output_delay -clock {sys_clk} -max  3.000 [get_ports {dac_data[*]}]
set_output_delay -clock {sys_clk} -min -1.000 [get_ports {dac_data[*]}]

# DDR output (both clock edges)
set_output_delay -clock {sys_clk}       -max 1.000 [get_ports {ddr_data[*]}]
set_output_delay -clock {sys_clk}       -min -1.000 [get_ports {ddr_data[*]}]
set_output_delay -clock {sys_clk} -fall -max 1.000 [get_ports {ddr_data[*]}]
set_output_delay -clock {sys_clk} -fall -min -1.000 [get_ports {ddr_data[*]}]

# DDR input (both clock edges)
set_input_delay -clock {sys_clk}       -max 3.000 [get_ports {ddr_q[*]}]
set_input_delay -clock {sys_clk}       -min 0.500 [get_ports {ddr_q[*]}]
set_input_delay -clock {sys_clk} -fall -max 3.000 [get_ports {ddr_q[*]}]
set_input_delay -clock {sys_clk} -fall -min 0.500 [get_ports {ddr_q[*]}]
