# ---
# VIRTUAL CLOCK CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
# See interfaces/virtual-clock/virtual-clock.xdc for full theory.
#
# Syntax in SDC is identical to Vivado XDC for virtual clocks —
# omit [get_ports] from create_clock to make it virtual.
# ---

set_time_format -unit ns -decimal_places 3

# Physical clock
create_clock -name {sys_clk} -period 20.000 [get_ports {clk}]
derive_pll_clocks
derive_clock_uncertainty

# Virtual clock — same period, no port reference
create_clock -name {virt_sys_clk} -period 20.000

# I/O delays reference the virtual clock
set_input_delay  -clock {virt_sys_clk} -max 7.000 [get_ports {adc_data[*]}]
set_input_delay  -clock {virt_sys_clk} -min 2.000 [get_ports {adc_data[*]}]
set_output_delay -clock {virt_sys_clk} -max 3.000 [get_ports {dac_data[*]}]
set_output_delay -clock {virt_sys_clk} -min -1.000 [get_ports {dac_data[*]}]

# Virtual clock is asynchronous to internal PLL outputs
# (same source but different propagation path)
set_clock_groups -asynchronous \
    -group [get_clocks {sys_clk}] \
    -group [get_clocks {virt_sys_clk}]
