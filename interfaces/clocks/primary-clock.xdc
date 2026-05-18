# Primary clock constraints — Xilinx Vivado (.xdc)
#
# Every design needs this. Without create_clock, Vivado has no idea how fast
# your clock runs and will either ignore timing or make up a number.
#
# Rule: define one create_clock for every external clock pin. Do this first,
# before any generated clocks, before any I/O delays.
#
# Period in ns = 1000 / frequency_MHz
#   50 MHz  → 20.0 ns
#   100 MHz → 10.0 ns
#   125 MHz →  8.0 ns
#   200 MHz →  5.0 ns

# ---
# Most common case: single-ended crystal oscillator
# Replace 10.0 with 1000/your_freq_MHz. Replace 'clk' with your port name.
create_clock -period 10.0 -name sys_clk -waveform {0.0 5.0} [get_ports clk]

# ---
# Differential clock (LVDS, LVPECL)
# Only constrain the P-side. Vivado handles the N-side automatically.
# If you also add create_clock on the N-side you'll get phantom CDC violations.
create_clock -period 10.0 -name sys_clk_diff [get_ports sys_clk_p]

# ---
# Multiple independent clocks (different oscillators = no phase relationship)
# You'll need set_clock_groups between these — see timing-patterns/clock-domain-crossing/
create_clock -period 10.0 -name sys_clk   [get_ports clk_100mhz]
create_clock -period  8.0 -name eth_clk   [get_ports clk_125mhz]

# ---
# Non-50% duty cycle
# -waveform {rise_ns fall_ns}. Default is {0.0 period/2} which is 50%.
create_clock -period 10.0 -name adc_clk -waveform {0.0 4.0} [get_ports adc_clk_in]

# ---
# After synthesis, check in Tcl console:
#   report_clocks
#   report_clock_networks
