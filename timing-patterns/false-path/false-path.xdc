# ---
# FALSE PATH PATTERNS  —  Xilinx Vivado (.xdc)
# ---
#
# set_false_path tells Vivado: "do NOT analyze timing on this path."
# Use it for paths where no timing relationship exists or matters:
#   - Asynchronous I/O (UART, push buttons, async resets)
#   - Test/debug signals that never operate at speed
#   - Paths already handled by RTL synchronizer (but use set_clock_groups instead
#     for full clock domains — false_path is for individual signals)
#
# FALSE PATH vs SET_CLOCK_GROUPS:
#   set_false_path -from [port] → one specific async port or cell
#   set_clock_groups -async    → entire clock domain (preferred for CDC)
#
# FALSE PATH vs SET_MAX_DELAY -datapath_only:
#   set_false_path        → completely excluded from analysis
#   set_max_delay -do     → excluded from clock skew but still checked for delay
#   Use set_max_delay -datapath_only for 2-FF synchronizer handshake paths.
#
# ---


# ---
# PATTERN 1: Async reset input port
# ---
set_false_path -from [get_ports sys_rst_n]


# ---
# PATTERN 2: Push buttons and slide switches (debounced in RTL)
# ---
set_false_path -from [get_ports {btn[*]}]
set_false_path -from [get_ports {sw[*]}]


# ---
# PATTERN 3: UART (async serial — no clock relationship)
# ---
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# PATTERN 4: Status LEDs and slow output indicators
# ---
# LEDs update at human-visible rates — no timing constraint needed.
set_false_path -to [get_ports {led[*]}]


# ---
# PATTERN 5: Test/debug output ports
# ---
# JTAG, logic analyser probes, debug headers — async, don't waste timing budget.
set_false_path -to [get_ports {debug[*]}]


# ---
# PATTERN 6: From a specific register to all outputs (broad exception)
# ---
# When a register's outputs go to multiple async destinations:
# set_false_path -from [get_cells {u_ctrl/status_reg[*]}]


# verify:
#   report_exceptions -summary        # All false paths in design
#   report_exceptions -ignored        # Any exceptions Vivado ignored (check this!)
