# ---
# I/O DELAY PATTERNS  —  Xilinx Vivado (.xdc)
# ---
#
# set_input_delay and set_output_delay are the core timing constraints
# for all synchronous I/O interfaces. They tell Vivado:
#   - How much of the clock cycle is "used up" outside the FPGA
#   - How much margin the FPGA's internal logic has left to work with
#
# THE TIMING BUDGET EQUATION:
#   For a source-synchronous input:
#     Internal_slack = period - set_input_delay_max - FPGA_internal_routing_delay
#   
#   For a system-synchronous output:
#     Internal_slack = period - set_output_delay_max - FPGA_internal_routing_delay
#
# SYSTEM-SYNCHRONOUS vs SOURCE-SYNCHRONOUS:
#   System-synchronous: Both FPGA and peripheral use the SAME clock reference.
#     → set_input_delay / set_output_delay relative to sys_clk
#   Source-synchronous: The clock travels WITH the data (e.g., SPI, LVDS, RGMII).
#     → create a generated clock on the output clock pin, constrain relative to it
#
# ---


# ---
# PATTERN 1: System-synchronous input (e.g., ADC with global clock, slow device)
# ---
#
# Scenario: An ADC provides data synchronous to your FPGA's sys_clk.
# Both the FPGA and ADC are driven from the same 50 MHz oscillator.
#
# Datasheet gives:
#   tCO_max = 7 ns  (ADC output valid within 7 ns of clock edge — worst case)
#   tCO_min = 2 ns  (ADC output valid within 2 ns of clock edge — best case)
#
# set_input_delay -max = tCO_max  (worst-case: data arrives late)
# set_input_delay -min = tCO_min  (best-case: data arrives early — for hold check)
#
set_input_delay -clock sys_clk -max 7.0 [get_ports {adc_data[*]}]
set_input_delay -clock sys_clk -min 2.0 [get_ports {adc_data[*]}]


# ---
# PATTERN 2: System-synchronous output (e.g., DAC, LCD controller)
# ---
#
# Scenario: Driving a DAC that shares sys_clk.
# DAC datasheet requires:
#   tSU = 3 ns  (data must be stable 3 ns BEFORE rising clock edge)
#   tH  = 1 ns  (data must hold for 1 ns AFTER rising clock edge)
#
# set_output_delay -max = tSU  (setup requirement of destination)
# set_output_delay -min = -tH  (negative of hold requirement)
#
set_output_delay -clock sys_clk -max  3.0 [get_ports {dac_data[*]}]
set_output_delay -clock sys_clk -min -1.0 [get_ports {dac_data[*]}]


# ---
# PATTERN 3: Source-synchronous output with generated output clock
# ---
#
# Scenario: FPGA drives both SCLK and data to a sensor. SCLK is a generated
# clock from your RTL (a divided version of sys_clk).
#
# Step 1: Create generated clock on the clock output pin
create_generated_clock \
    -name sensor_sclk \
    -source [get_ports clk] \
    -divide_by 8 \
    [get_ports sensor_sclk]

# Step 2: Constrain data output relative to that generated clock
#   Sensor requires tSU=5ns, tH=2ns
set_output_delay -clock sensor_sclk -max  5.0 [get_ports {sensor_data[*]}]
set_output_delay -clock sensor_sclk -min -2.0 [get_ports {sensor_data[*]}]


# ---
# PATTERN 4: DDR output delays (data changes on both edges)
# ---
#
# For DDR interfaces, constrain both rising and falling edge captures separately.
# Use -clock_fall for falling-edge captures.

set_output_delay -clock sys_clk            -max 1.0 [get_ports {ddr_data[*]}]
set_output_delay -clock sys_clk            -min -1.0 [get_ports {ddr_data[*]}]
set_output_delay -clock sys_clk -clock_fall -max 1.0 [get_ports {ddr_data[*]}]
set_output_delay -clock sys_clk -clock_fall -min -1.0 [get_ports {ddr_data[*]}]


# ---
# PATTERN 5: Bidirectional port (input and output delay on same port)
# ---
#
# Bidirectional ports need BOTH set_input_delay and set_output_delay.
# The direction is controlled by your RTL's tristate logic.

set_input_delay  -clock sys_clk -max 5.0 [get_ports {bidir_bus[*]}]
set_input_delay  -clock sys_clk -min 1.0 [get_ports {bidir_bus[*]}]
set_output_delay -clock sys_clk -max 3.0 [get_ports {bidir_bus[*]}]
set_output_delay -clock sys_clk -min -1.0 [get_ports {bidir_bus[*]}]


# ---
# HOW TO DERIVE VALUES FROM YOUR DATASHEET:
# ---
#
# Look for these parameters in the "DC and AC Characteristics" or
# "Timing Diagrams" section of your peripheral's datasheet:
#
#   For set_input_delay:
#     -max → tCO_max, tOUT_max, tPD_max (output delay, propagation delay)
#     -min → tCO_min, tOUT_min, tPD_min
#
#   For set_output_delay:
#     -max → tSU (setup time at destination)
#     -min → negative of tH (hold time at destination)
#
# Include PCB trace delay if known:
#   Each cm of FR4 trace ≈ 60 ps delay
#   Add this to -max, subtract from -min
#
# VERIFICATION:
#   report_timing_summary -datasheet    # Shows all I/O timing
#   report_io_timing                    # Dedicated I/O timing report
