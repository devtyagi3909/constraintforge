# ---
# MULTICYCLE PATH PATTERNS  —  Intel Quartus Prime (.sdc)
# ---
# See timing-patterns/multicycle-path/multicycle.xdc for full theory.
# Quartus SDC syntax is nearly identical to Vivado XDC syntax.
# ---

set_time_format -unit ns -decimal_places 3

# Pattern 1: 2-cycle path, specific cells
set_multicycle_path -setup 2 \
    -from [get_registers {u_datapath:operand_a_reg[*]}] \
    -to   [get_registers {u_datapath:result_reg[*]}]

set_multicycle_path -hold 1 \
    -from [get_registers {u_datapath:operand_a_reg[*]}] \
    -to   [get_registers {u_datapath:result_reg[*]}]

# Pattern 2: Across synchronous clock groups (100 MHz → 50 MHz)
set_multicycle_path -setup 2 -from [get_clocks {clk_100mhz}] -to [get_clocks {clk_50mhz}]
set_multicycle_path -hold  1 -from [get_clocks {clk_100mhz}] -to [get_clocks {clk_50mhz}]
