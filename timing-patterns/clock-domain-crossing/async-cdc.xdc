# Clock domain crossing — Xilinx Vivado (.xdc)
#
# When a signal moves from one clock domain to another, two things are required:
#   1. RTL: a proper synchronizer (2-FF synchronizer, async FIFO, handshake)
#   2. XDC: tell Vivado the clocks are unrelated so it stops trying to time
#      the crossing path (which it cannot do correctly)
#
# Both are mandatory. XDC alone doesn't prevent metastability.
# RTL alone without set_clock_groups produces false timing violations.
#
# set_clock_groups vs set_false_path:
#   set_clock_groups → use for entire clock domains (most CDC situations)
#   set_false_path   → use for individual signals (async reset, single flag)

# ---
# Two independent async clocks (most common case)
set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks sys_clk] \
    -group [get_clocks -include_generated_clocks eth_clk]

# ---
# Three async clock domains at once
set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks sys_clk] \
    -group [get_clocks -include_generated_clocks ddr_ui_clk] \
    -group [get_clocks -include_generated_clocks adc_clk]

# ---
# Async reset — false path (one-directional, not a full clock domain)
set_false_path -from [get_ports sys_rst_n]

# ---
# Handshake across domains (2-FF synchronizer)
# set_max_delay -datapath_only relaxes timing without suppressing clock skew analysis
# 5.0 = one source clock period (adjust for your frequency)
# The destination FFs need (* ASYNC_REG = "TRUE" *) in your RTL
# set_max_delay -datapath_only 5.0 \
#     -from [get_cells {u_src/flag_reg}] \
#     -to   [get_cells {u_dst/sync_ff_reg[0]}]

# ---
# Exclusive clocks (mux — only one active at a time)
# set_clock_groups -exclusive \
#     -group [get_clocks clk_normal] \
#     -group [get_clocks clk_test]

# ---
# Check:
#   report_cdc -details
#   check_cdc -problem_types all
