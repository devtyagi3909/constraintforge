# ---
# PRIMARY CLOCK CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
#
# SDC = Synopsys Design Constraints. Intel Quartus uses SDC format for timing.
# It is industry-standard and closely mirrors Xilinx XDC syntax.
#
# CRITICAL ORDER: Always place create_clock commands FIRST in your .sdc file,
# before any set_input_delay, set_output_delay, or other exceptions.
#
# ---


# ---
# STEP 0 (REQUIRED): Set time format — always include this at the top
# ---
#
# Quartus SDC files should always begin with this line.
# It sets nanosecond units with 3 decimal places of precision.
#
set_time_format -unit ns -decimal_places 3


# ---
# EXAMPLE 1: Single-ended 50 MHz system clock (DE10-Nano default)
# ---
#
# -name {clk}        : Logical clock name used in reports and other constraints
# -period 20.000     : Period in ns. 50 MHz = 20 ns
# -waveform {0 10}   : Rise at 0 ns, fall at 10 ns (50% duty cycle)
# [get_ports {clk}]  : The port name from your Verilog/VHDL top-level
#
create_clock -name {sys_clk} -period 20.000 -waveform {0.000 10.000} [get_ports {clk}]


# ---
# EXAMPLE 2: 100 MHz system clock
# ---
create_clock -name {sys_clk_100} -period 10.000 -waveform {0.000 5.000} [get_ports {clk_100mhz}]


# ---
# EXAMPLE 3: Multiple independent clocks
# ---
create_clock -name {sys_clk}  -period 20.000 [get_ports {clk_50mhz}]
create_clock -name {adc_clk}  -period  8.000 [get_ports {adc_clk}]
create_clock -name {eth_gtx}  -period  8.000 [get_ports {eth_gtx_clk}]


# ---
# STEP 1 (REQUIRED): derive_pll_clocks
# ---
#
# This Quartus-specific command automatically creates clock constraints for
# ALL PLL outputs in your design. It introspects the PLL configuration and
# derives the correct clock names, periods, and phase relationships.
#
# ALWAYS include this after your primary clock definitions.
# Without it, PLL output clocks are unconstrained → timing analysis is wrong.
#
derive_pll_clocks


# ---
# STEP 2 (REQUIRED): derive_clock_uncertainty
# ---
#
# This Quartus-specific command automatically calculates clock uncertainty
# (jitter, skew) based on the device family and your clock topology.
# It's the equivalent of set_clock_uncertainty with device-specific models.
#
# ALWAYS include this. It is required for accurate timing analysis.
# Place it AFTER derive_pll_clocks.
#
derive_clock_uncertainty


# ---
# EXAMPLE 4: Non-50% duty cycle clock
# ---
#
# 125 MHz Ethernet RGMII RX clock — typically has tight duty cycle requirements
# RGMII spec: 1 ns minimum high/low period at 125 MHz (8 ns period)
#
create_clock -name {rgmii_rx_clk} -period 8.000 -waveform {0.000 4.000} [get_ports {eth_rxclk}]


# verify:
#   Processing → Timing Analyzer → Report Clocks
#   Processing → Timing Analyzer → Report Fmax Summary
#
# Or from command line:
#   quartus_sta <project_name> --do_report_timing
