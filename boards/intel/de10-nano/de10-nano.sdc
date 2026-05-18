# ---
# DE10-Nano Timing Constraints (SDC)
# Device: Intel Cyclone V SE 5CSEBA6U23I7
# Board:  Terasic DE10-Nano
#
# USAGE: Add to your Quartus project .qsf:
#   set_global_assignment -name SDC_FILE de10-nano.sdc
#
# This file defines all clock constraints and common timing exceptions
# for the DE10-Nano board. Pin assignments are in de10-nano.qsf.
#
# ---

set_time_format -unit ns -decimal_places 3


# ---
# PRIMARY CLOCKS
# ---

# FPGA_CLK1_50 — 50 MHz on-board oscillator (main system clock)
create_clock -name {FPGA_CLK1_50} \
    -period 20.000 \
    -waveform {0.000 10.000} \
    [get_ports {FPGA_CLK1_50}]

# FPGA_CLK2_50 — 50 MHz second oscillator (independent, use for separate domain)
create_clock -name {FPGA_CLK2_50} \
    -period 20.000 \
    -waveform {0.000 10.000} \
    [get_ports {FPGA_CLK2_50}]

# FPGA_CLK3_50 — 50 MHz third oscillator (DDR3 reference clock region)
create_clock -name {FPGA_CLK3_50} \
    -period 20.000 \
    -waveform {0.000 10.000} \
    [get_ports {FPGA_CLK3_50}]


# ---
# PLL / FMAX DERIVATION (required in every Quartus SDC)
# ---

# Automatically creates generated clock constraints for ALL PLL outputs.
# Must come AFTER all create_clock statements.
derive_pll_clocks

# Models jitter and clock uncertainty for all clocks in the design.
# Must come AFTER derive_pll_clocks.
derive_clock_uncertainty


# ---
# CLOCK DOMAIN CROSSINGS
# ---
#
# FPGA_CLK1_50, FPGA_CLK2_50, FPGA_CLK3_50 come from independent oscillators.
# They have NO phase or frequency relationship — declare them asynchronous.
#
# Remove/comment any groups that your design does NOT use.

set_clock_groups -asynchronous \
    -group [get_clocks {FPGA_CLK1_50}] \
    -group [get_clocks {FPGA_CLK2_50}] \
    -group [get_clocks {FPGA_CLK3_50}]

# If using the HPS-to-FPGA bridge clocks (h2f_user0_clk etc.), add them here:
# set_clock_groups -asynchronous \
#     -group [get_clocks {FPGA_CLK1_50}] \
#     -group [get_clocks {*h2f_user0_clk*}]


# ---
# FALSE PATHS — Async signals with no timing relationship
# ---

# Push buttons (active low, debounced in RTL)
set_false_path -from [get_ports {KEY[0]}]
set_false_path -from [get_ports {KEY[1]}]

# Slide switches (async user input)
set_false_path -from [get_ports {SW[0]}]
set_false_path -from [get_ports {SW[1]}]
set_false_path -from [get_ports {SW[2]}]
set_false_path -from [get_ports {SW[3]}]

# LEDs — driven by FPGA, no incoming timing constraint needed
set_false_path -to [get_ports {USER_LED[*]}]

# Arduino UART (asynchronous serial)
set_false_path -from [get_ports {ARDUINO_RXD}]
set_false_path -to   [get_ports {ARDUINO_TXD}]

# Arduino I/O header — treat as async unless you constrain individually
set_false_path -from [get_ports {ARDUINO_IO[*]}]
set_false_path -to   [get_ports {ARDUINO_IO[*]}]

# GPIO expansion headers — async unless explicitly constrained per signal
set_false_path -from [get_ports {GPIO_0[*]}]
set_false_path -to   [get_ports {GPIO_0[*]}]


# ---
# HPS (Hard Processor System) INTERFACE
# ---
#
# When using the Cyclone V HPS, the HPS-FPGA interface is managed by the
# Platform Designer (Qsys) system. The generated .sdc from Platform Designer
# contains the correct constraints for h2f_clk, f2h_clk, AXI bridges, etc.
#
# Include those generated constraints AFTER this file in your .qsf:
#   set_global_assignment -name SDC_FILE hps_isw_handoff/system_0/pin_assignments.sdc
#
# If constraining HPS UART (routed to USB-UART bridge chip on DE10-Nano):
set_false_path -from [get_ports {HPS_UART_RX}]
set_false_path -to   [get_ports {HPS_UART_TX}]

# HPS DDR3 — constrained by EMIF IP auto-generated SDC, NOT here.
# HPS Ethernet — constrained by Platform Designer generated SDC.
# HPS SD Card — constrained by Platform Designer generated SDC.


# ---
# VERIFICATION CHECKLIST
# ---
#
# After Quartus compilation:
#   1. Open Timing Analyzer → Report Clocks
#      → All 3 primary clocks should appear at 50.000 MHz
#      → PLL outputs should appear as generated clocks
#
#   2. Report Fmax Summary
#      → Check all clock domains meet timing
#
#   3. Report Clock Transfers
#      → All async crossings should show "Not Analyzed" (covered by set_clock_groups)
#
#   4. Report Unconstrained Paths
#      → Should be 0 (or only intentionally unconstrained debug signals)
