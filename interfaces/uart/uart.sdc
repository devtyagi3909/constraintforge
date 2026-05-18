# ---
# UART CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
#
# UART is asynchronous — use set_false_path, not set_input_delay.
# This file assumes you have already defined your primary clock in your main .sdc
# using create_clock and derived PLL clocks with derive_pll_clocks.
#
# ---


# ---
# False path on all UART signals
# ---
#
# Tells the Timing Analyzer: skip all paths to/from UART pins.
# The correct approach for any asynchronous serial interface.
#
# Replace uart_txd and uart_rxd with your actual port names from HDL.
#
set_false_path -from [get_ports {uart_rxd}]
set_false_path -to   [get_ports {uart_txd}]

# Optional: UART flow control
# set_false_path -from [get_ports {uart_cts}]
# set_false_path -to   [get_ports {uart_rts}]


# ---
# Pin assignments for UART (Quartus QSF assignment format)
# These can also go in your .qsf file directly.
# ---
#
# DE10-Nano example (Arduino header UART via MAX3232):
# set_location_assignment PIN_V10 -to uart_txd
# set_location_assignment PIN_W10 -to uart_rxd
#
# For pure SDC files, pin assignments belong in the .qsf.
# See boards/intel/de10-nano/de10-nano.qsf for board-specific pin assignments.


# ---
# In Quartus, pin location and I/O standard assignments are typically
# made in the .qsf file, NOT in the .sdc file. The .sdc file is purely for
# timing constraints (clocks, delays, exceptions).
