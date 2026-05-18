# Virtual clock constraints — Xilinx Vivado (.xdc)
#
# A virtual clock is used in set_input_delay / set_output_delay when the
# reference clock doesn't physically enter the FPGA.
#
# When do you need this?
#   You share a board oscillator with a peripheral chip. The oscillator drives
#   both your FPGA clock pin AND the peripheral directly. When you write
#   set_input_delay for that peripheral's outputs, which clock do you reference?
#   Not sys_clk — that's the clock as it enters the FPGA, which includes
#   any IBUF/MMCM propagation delay. The peripheral sees the raw oscillator.
#   That raw oscillator = virtual clock.
#
# create_clock without [get_ports] = virtual clock.

# ---
# Physical clock (enters the FPGA normally)
create_clock -period 10.0 -name sys_clk [get_ports clk]

# Virtual clock — same source, same period, no port
create_clock -period 10.0 -name virt_sys_clk
#                                               ^^^ no [get_ports] — that's it

# ---
# Use the virtual clock in I/O delay constraints
set_input_delay  -clock virt_sys_clk -max 7.0 [get_ports {adc_data[*]}]
set_input_delay  -clock virt_sys_clk -min 2.0 [get_ports {adc_data[*]}]
set_output_delay -clock virt_sys_clk -max 3.0 [get_ports {dac_data[*]}]
set_output_delay -clock virt_sys_clk -min -1.0 [get_ports {dac_data[*]}]

# ---
# If there's a known trace delay between the oscillator and the peripheral
# (about 60 ps per cm of FR4), model it with -waveform:
# create_clock -period 10.0 -name virt_delayed -waveform {1.2 6.2}
# That shifts the virtual clock's rising edge to 1.2 ns (1.2 ns trace delay)

# ---
# Check it worked:
#   report_clocks
#   → virtual clocks appear without an associated port/pin
