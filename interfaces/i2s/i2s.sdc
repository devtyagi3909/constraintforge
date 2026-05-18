# ---
# I2S AUDIO CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
# I2S is source-synchronous audio serial. See interfaces/i2s/i2s.xdc for theory.
# ---

set_time_format -unit ns -decimal_places 3

# Primary system clock
create_clock -name {sys_clk} -period 20.000 [get_ports {clk}]
derive_pll_clocks
derive_clock_uncertainty


# ---
# FPGA as I2S Master — generated clock on BCLK output
# ---
# 50 MHz sys_clk ÷ 16 = 3.125 MHz BCLK (close to 3.072 MHz for 48 kHz audio)
create_generated_clock \
    -name {i2s_bclk_gen} \
    -source [get_ports {clk}] \
    -divide_by 16 \
    [get_ports {i2s_bclk}]

create_generated_clock \
    -name {i2s_mclk_gen} \
    -source [get_ports {clk}] \
    -divide_by 4 \
    [get_ports {i2s_mclk}]


# SDATA TX — output changes on falling BCLK edge
set_output_delay -clock {i2s_bclk_gen} -max  10.000 -fall [get_ports {i2s_sdata_tx}]
set_output_delay -clock {i2s_bclk_gen} -min   0.000 -fall [get_ports {i2s_sdata_tx}]

set_output_delay -clock {i2s_bclk_gen} -max  10.000 -fall [get_ports {i2s_lrclk}]
set_output_delay -clock {i2s_bclk_gen} -min   0.000 -fall [get_ports {i2s_lrclk}]

# SDATA RX — codec presents data after rising BCLK edge
set_input_delay -clock {i2s_bclk_gen} -max 15.000 [get_ports {i2s_sdata_rx}]
set_input_delay -clock {i2s_bclk_gen} -min  0.000 [get_ports {i2s_sdata_rx}]


# ---
# If FPGA is I2S Slave (codec drives BCLK/LRCLK) — swap with above
# ---
# create_clock -name {i2s_bclk} -period 325.521 [get_ports {i2s_bclk}]
# set_input_delay -clock {i2s_bclk} -max 290.000 [get_ports {i2s_sdata_rx}]
# set_input_delay -clock {i2s_bclk} -min  10.000 [get_ports {i2s_sdata_rx}]
# set_output_delay -clock {i2s_bclk} -max 10.000 -fall [get_ports {i2s_sdata_tx}]
# set_output_delay -clock {i2s_bclk} -min  0.000 -fall [get_ports {i2s_sdata_tx}]
# set_clock_groups -asynchronous -group [get_clocks {i2s_bclk}] -group [get_clocks {sys_clk}]
