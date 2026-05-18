# ---
# LVDS SOURCE-SYNCHRONOUS INPUT CONSTRAINTS  —  Xilinx Vivado (.xdc)
# ---
#
# LVDS (Low-Voltage Differential Signaling) is commonly used for
# high-speed data interfaces — ADCs, camera sensors, high-speed serial links.
# It is a SOURCE-SYNCHRONOUS interface: the transmitter sends a differential
# clock alongside the differential data. The FPGA must capture data using
# that incoming clock, NOT its internal system clock.
#
# Common LVDS use cases on FPGAs:
#   - ADC data output (e.g., ADS527x, LTC2387, AD9680)
#   - Camera parallel data (e.g., OV5640 parallel LVDS output)
#   - High-speed DAQ interfaces
#   - LVDS-based inter-FPGA communication
#
# LVDS TIMING PARAMETERS (from the data source's datasheet):
#   tDV  : Data valid window = tSU + tH (total valid window around clock edge)
#   tSU  : Setup time (data must be valid this many ns BEFORE clock edge)
#   tH   : Hold time  (data must remain valid this many ns AFTER clock edge)
#
# ---


# LVDS Clock Input — define as PRIMARY CLOCK
#
# The differential clock from the source (ADC/camera/etc.) is a primary clock.
# Only constrain the P-side pin. The N-side is automatically handled by Vivado.
#
# Example: ADC sends 100 MSPS data with a 100 MHz differential clock
#   → period = 10 ns
#
create_clock -period 10.0 -name lvds_rx_clk [get_ports lvds_clk_p]

# If it's a DDR interface (data changes on both clock edges, doubling bandwidth):
# create_clock -period 5.0 -name lvds_rx_clk [get_ports lvds_clk_p]
# The above 5 ns period treats each clock edge as a data boundary.


# Pin Location and I/O Standard
#
# LVDS pins MUST be in a bank with sufficient VCCO (typically 2.5V for LVDS
# on 7-Series, or 1.8V for UltraScale LVDS with internal termination).
#
# All LVDS pairs must use DIFF_SSTL or LVDS standard.
# Standard 7-Series: use LVDS_25 for 2.5V I/O bank
# UltraScale/+: use LVDS or LVDS_25
#
set_property PACKAGE_PIN <CLK_P_PIN>   [get_ports lvds_clk_p]
set_property PACKAGE_PIN <CLK_N_PIN>   [get_ports lvds_clk_n]
set_property PACKAGE_PIN <DATA_P_PIN0> [get_ports {lvds_data_p[0]}]
set_property PACKAGE_PIN <DATA_N_PIN0> [get_ports {lvds_data_n[0]}]
set_property PACKAGE_PIN <DATA_P_PIN1> [get_ports {lvds_data_p[1]}]
set_property PACKAGE_PIN <DATA_N_PIN1> [get_ports {lvds_data_n[1]}]

set_property IOSTANDARD LVDS_25 [get_ports lvds_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports lvds_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports {lvds_data_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {lvds_data_n[*]}]

# Internal termination (DIFF_TERM):
# LVDS receivers need termination at the destination. FPGAs can provide this
# internally (saves an external resistor) with DIFF_TERM = TRUE.
# Use internal termination only if your PCB trace is properly matched.
set_property DIFF_TERM TRUE [get_ports lvds_clk_p]
set_property DIFF_TERM TRUE [get_ports lvds_clk_n]
set_property DIFF_TERM TRUE [get_ports {lvds_data_p[*]}]
set_property DIFF_TERM TRUE [get_ports {lvds_data_n[*]}]


# Source-Synchronous Input Timing
#
# set_input_delay constrains how much time the data is valid before/after
# the incoming clock edge. The reference clock IS the incoming LVDS clock
# (not your internal system clock).
#
# The timing parameters come from the source device's datasheet:
#
#   EXAMPLE: ADC with:
#     tSU = 0.6 ns (data setup before clock edge)
#     tH  = 0.4 ns (data hold after clock edge)
#
# FORMULA:
#   -max = period - tSU  [maximum skew = data must arrive before clock]
#   -min = tH            [minimum skew = data valid after clock]
#
# Wait — which edge? For SDR (single data rate), data is captured on rising edge.
# For DDR (dual data rate), use -clock_fall for the falling-edge capture:
#
# --- SDR (Single Data Rate) ---
set_input_delay -clock lvds_rx_clk -max 9.4 [get_ports {lvds_data_p[*]}]
set_input_delay -clock lvds_rx_clk -min 0.4 [get_ports {lvds_data_p[*]}]

# --- DDR (Dual Data Rate) — captures on both edges ---
# Rising-edge capture (default):
# set_input_delay -clock lvds_rx_clk -max 4.4 [get_ports {lvds_data_p[*]}]
# set_input_delay -clock lvds_rx_clk -min 0.4 [get_ports {lvds_data_p[*]}]
# Falling-edge capture (add -clock_fall):
# set_input_delay -clock_fall -clock lvds_rx_clk -max 4.4 [get_ports {lvds_data_p[*]}]
# set_input_delay -clock_fall -clock lvds_rx_clk -min 0.4 [get_ports {lvds_data_p[*]}]


# CDC to System Clock Domain
#
# Data captured on lvds_rx_clk must cross into your sys_clk domain.
# This crossing MUST use an async FIFO or 2-FF synchronizer in RTL.
# Tell Vivado about the asynchronous relationship:
#
set_clock_groups -asynchronous \
    -group [get_clocks lvds_rx_clk] \
    -group [get_clocks sys_clk]
#
# This prevents Vivado from trying to time the cross-domain paths
# (which it cannot do correctly since the clocks are unrelated).


# IDELAY (Optional — for fine-tuning data capture timing)
#
# If your source-synchronous setup/hold window is very tight (< 1 ns), you
# can use IDELAY primitives to add programmable delay to each data bit
# independently, centering the sampling point in the data valid window.
#
# This is done in RTL (instantiate IDELAYE2 or IDELAYE3) and controlled at
# runtime via the FPGA's delay calibration logic.
# No additional XDC is needed for IDELAY beyond the I/O standard settings above.
# Ensure IDELAYCTRL is instantiated and driven by a 200 MHz refclk.


# ---
#   [ ] LVDS pins in correct bank with matching VCCO
#   [ ] DIFF_TERM set correctly for your PCB topology
#   [ ] Period set to match source clock exactly
#   [ ] set_input_delay -max/-min derived from source device datasheet
#   [ ] set_clock_groups for CDC to sys_clk domain
#   [ ] RTL has IBUFDS primitives for all LVDS inputs
