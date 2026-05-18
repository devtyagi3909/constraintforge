# ---
# DE1-SoC Timing Constraints (SDC)
# Device: Intel Cyclone V SoC 5CSEMA5F31C6N
# Board:  Terasic DE1-SoC
#
# USAGE: Add to your Quartus project .qsf:
#   set_global_assignment -name SDC_FILE de1-soc.sdc
#
# ---

set_time_format -unit ns -decimal_places 3


# ---
# PRIMARY CLOCKS  —  4 independent 50 MHz oscillators
# ---

create_clock -name {CLOCK_50} \
    -period 20.000 -waveform {0.000 10.000} [get_ports {CLOCK_50}]

create_clock -name {CLOCK2_50} \
    -period 20.000 -waveform {0.000 10.000} [get_ports {CLOCK2_50}]

create_clock -name {CLOCK3_50} \
    -period 20.000 -waveform {0.000 10.000} [get_ports {CLOCK3_50}]

create_clock -name {CLOCK4_50} \
    -period 20.000 -waveform {0.000 10.000} [get_ports {CLOCK4_50}]


# ---
# PLL DERIVATION (required)
# ---

derive_pll_clocks
derive_clock_uncertainty


# ---
# ASYNC CLOCK GROUPS
# ---
#
# All 4 oscillators are independent — no timing relationship between them.

set_clock_groups -asynchronous \
    -group [get_clocks {CLOCK_50}] \
    -group [get_clocks {CLOCK2_50}] \
    -group [get_clocks {CLOCK3_50}] \
    -group [get_clocks {CLOCK4_50}]


# ---
# FALSE PATHS — Async I/O
# ---

# Push buttons (active low)
set_false_path -from [get_ports {KEY[*]}]

# Slide switches
set_false_path -from [get_ports {SW[*]}]

# LEDs (output only, no setup/hold requirement)
set_false_path -to [get_ports {LEDR[*]}]

# 7-Segment displays (output only, driven at human-visible rates)
set_false_path -to [get_ports {HEX0[*]}]
set_false_path -to [get_ports {HEX1[*]}]
set_false_path -to [get_ports {HEX2[*]}]
set_false_path -to [get_ports {HEX3[*]}]
set_false_path -to [get_ports {HEX4[*]}]
set_false_path -to [get_ports {HEX5[*]}]

# GPIO expansion headers (async unless constrained per signal)
set_false_path -from [get_ports {GPIO_0[*]}]
set_false_path -to   [get_ports {GPIO_0[*]}]
set_false_path -from [get_ports {GPIO_1[*]}]
set_false_path -to   [get_ports {GPIO_1[*]}]


# ---
# HPS INTERFACE
# ---

# HPS UART (USB-UART bridge via FTDI)
set_false_path -from [get_ports {HPS_UART_RX}]
set_false_path -to   [get_ports {HPS_UART_TX}]

# HPS DDR3, Ethernet, SD — all constrained by EMIF/Platform Designer generated SDC.
# Include Platform Designer generated timing constraints in your .qsf:
#   set_global_assignment -name SDC_FILE soc_system/synthesis/submodules/soc_system_hps_0.sdc
