# ---
# Tang Nano 9K Timing Constraints (SDC)
# Device: Gowin GW1NR-9C
# Board:  Sipeed Tang Nano 9K
#
# USAGE in Gowin EDA:
#   Project → Project Settings → Timing Constraints → Add this file
#
# Gowin EDA uses SDC format (same as Intel Quartus/Synopsys).
# ---

set_time_format -unit ns -decimal_places 3


# ---
# PRIMARY CLOCK  —  27 MHz on-board crystal
# ---

create_clock -name {clk_27mhz} \
    -period 37.037 \
    -waveform {0.000 18.519} \
    [get_ports {clk_27mhz}]


# ---
# PLL CLOCKS  —  Gowin rPLL (replaces derive_pll_clocks)
# ---
#
# Gowin EDA does NOT support derive_pll_clocks.
# If you use rPLL in your design, manually define generated clocks:
#
# Example: rPLL configured to output 27 MHz × 4 = 108 MHz
# create_generated_clock \
#     -name {pll_clk} \
#     -source [get_ports {clk_27mhz}] \
#     -multiply_by 4 \
#     [get_nets {u_pll/CLKOUT}]


# ---
# FALSE PATHS  —  Async I/O
# ---

# Push buttons (active low)
set_false_path -from [get_ports {btn[0]}]
set_false_path -from [get_ports {btn[1]}]

# LEDs (output only)
set_false_path -to [get_ports {led[0]}]
set_false_path -to [get_ports {led[1]}]
set_false_path -to [get_ports {led[2]}]
set_false_path -to [get_ports {led[3]}]
set_false_path -to [get_ports {led[4]}]
set_false_path -to [get_ports {led[5]}]

# UART (asynchronous serial)
set_false_path -from [get_ports {uart_rx}]
set_false_path -to   [get_ports {uart_tx}]

# HDMI outputs (TMDS — clock recovery at receiver)
set_false_path -to [get_ports {hdmi_clk_p}]
set_false_path -to [get_ports {hdmi_clk_n}]
set_false_path -to [get_ports {hdmi_d0_p}]
set_false_path -to [get_ports {hdmi_d0_n}]
set_false_path -to [get_ports {hdmi_d1_p}]
set_false_path -to [get_ports {hdmi_d1_n}]
set_false_path -to [get_ports {hdmi_d2_p}]
set_false_path -to [get_ports {hdmi_d2_n}]
