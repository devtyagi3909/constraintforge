# ---
# FALSE PATH PATTERNS  —  Intel Quartus Prime (.sdc)
# ---
# See timing-patterns/false-path/false-path.xdc for full theory.
# ---

set_time_format -unit ns -decimal_places 3

set_false_path -from [get_ports {sys_rst_n}]
set_false_path -from [get_ports {KEY[*]}]
set_false_path -from [get_ports {SW[*]}]
set_false_path -from [get_ports {uart_rxd}]
set_false_path -to   [get_ports {uart_txd}]
set_false_path -to   [get_ports {USER_LED[*]}]
