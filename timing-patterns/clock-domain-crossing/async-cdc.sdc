# ---
# CLOCK DOMAIN CROSSING PATTERNS  —  Intel Quartus Prime (.sdc)
# ---
# See timing-patterns/clock-domain-crossing/async-cdc.xdc for full theory.
# ---

set_time_format -unit ns -decimal_places 3

# Pattern 1: Two independent async clock domains
set_clock_groups -asynchronous \
    -group [get_clocks {sys_clk}] \
    -group [get_clocks {eth_rxclk}]

# Pattern 2: Multiple async clock groups
set_clock_groups -asynchronous \
    -group [get_clocks {sys_clk}] \
    -group [get_clocks {adc_clk}] \
    -group [get_clocks {*afi_clk*}]

# Pattern 3: Async reset / single async signal
set_false_path -from [get_ports {sys_rst_n}]

# Pattern 4: Handshake — relax timing to first sync FF only
# 20.0 = one source period at 50 MHz. Adjust for your clock.
# set_max_delay -from [get_registers {u_src:flag_reg}] \
#               -to   [get_registers {u_dst:sync_ff[0]}] \
#               20.0

# Pattern 5: Exclusive clocks (mux select)
# set_clock_groups -exclusive \
#     -group [get_clocks {clk_normal}] \
#     -group [get_clocks {clk_test}]
