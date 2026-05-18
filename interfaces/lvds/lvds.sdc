# ---
# LVDS SOURCE-SYNCHRONOUS INPUT CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
#
# LVDS brings its own clock alongside data. Constrain the incoming clock as a
# primary clock, then use set_input_delay relative to it.
#
# ---

set_time_format -unit ns -decimal_places 3

# ---
# Primary clock — the LVDS source clock coming in from external device
# ---
# Replace 10.000 with 1000/freq_MHz for your source device.
# Only constrain the positive side of the differential pair.
create_clock -name {lvds_rx_clk} -period 10.000 -waveform {0.000 5.000} \
    [get_ports {lvds_clk_p}]

# After primary clocks, derive PLLs and uncertainty as usual:
# derive_pll_clocks
# derive_clock_uncertainty


# ---
# Source-synchronous input delay for LVDS data lines
# ---
#
# Timing parameters from your source device datasheet:
#   tSU = data setup time before clock edge (ns)
#   tH  = data hold  time after  clock edge (ns)
#
# set_input_delay -max = period - tSU   (SDR example: 10.0 - 0.6 = 9.4)
# set_input_delay -min = tH             (SDR example: 0.4)
#
# SDR (single data rate — data captured on rising edge only):
set_input_delay -clock {lvds_rx_clk} -max 9.400 [get_ports {lvds_data_p[*]}]
set_input_delay -clock {lvds_rx_clk} -min 0.400 [get_ports {lvds_data_p[*]}]

# DDR (dual data rate — captured on both edges):
# set_input_delay -clock {lvds_rx_clk} -max 4.400 [get_ports {lvds_data_p[*]}]
# set_input_delay -clock {lvds_rx_clk} -min 0.400 [get_ports {lvds_data_p[*]}]
# set_input_delay -clock {lvds_rx_clk} -max 4.400 -clock_fall [get_ports {lvds_data_p[*]}]
# set_input_delay -clock {lvds_rx_clk} -min 0.400 -clock_fall [get_ports {lvds_data_p[*]}]


# ---
# CDC: LVDS clock domain → system clock domain
# ---
# If your design crosses from lvds_rx_clk to another clock, declare them async:
set_clock_groups -asynchronous \
    -group [get_clocks {lvds_rx_clk}] \
    -group [get_clocks {sys_clk}]
