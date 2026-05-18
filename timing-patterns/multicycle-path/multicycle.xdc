# Multicycle path — Xilinx Vivado (.xdc)
#
# By default Vivado requires every combinational path to complete in one clock
# cycle. A multicycle path exception relaxes this for paths your RTL intentionally
# takes multiple cycles to complete (e.g. a multiplier that outputs on cycle 2,
# a clock-enabled datapath that only changes every N cycles).
#
# Never use this just to silence failing timing. Only apply it when your RTL
# actually guarantees the data is stable for N cycles before being sampled.
#
# Always pair -setup N with -hold (N-1). Forgetting -hold causes hold violations
# in hardware even if timing analysis passes.

# ---
# 2-cycle path between specific cells (most common)
set_multicycle_path -setup 2 \
    -from [get_cells {u_datapath/operand_a_reg[*]}] \
    -to   [get_cells {u_datapath/result_reg[*]}]

set_multicycle_path -hold 1 \
    -from [get_cells {u_datapath/operand_a_reg[*]}] \
    -to   [get_cells {u_datapath/result_reg[*]}]

# ---
# Synchronous clocks with integer ratio (clk_100 → clk_50)
# Don't use this for async clocks — use set_clock_groups instead
set_multicycle_path -setup 2 -from [get_clocks clk_100] -to [get_clocks clk_50]
set_multicycle_path -hold  1 -from [get_clocks clk_100] -to [get_clocks clk_50]

# ---
# Config registers that don't change at runtime
set_multicycle_path -setup 3 \
    -from [get_cells {u_cfg/config_reg[*]}] \
    -to   [get_cells {u_core/pipe_stage_reg[*]}]

set_multicycle_path -hold 2 \
    -from [get_cells {u_cfg/config_reg[*]}] \
    -to   [get_cells {u_core/pipe_stage_reg[*]}]

# ---
# After adding, verify:
#   report_timing -from [get_cells {src}] -to [get_cells {dst}]
#   Look for "Multicycle Path: N" in the timing path header
