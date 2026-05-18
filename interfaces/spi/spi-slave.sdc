# ---
# SPI SLAVE CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
# FPGA is the SPI slave. External master drives SCLK as a primary clock.
# See interfaces/spi/spi-slave.xdc for full theory, mode explanation, and
# timing derivation from datasheet parameters.
# ---

set_time_format -unit ns -decimal_places 3

# Prerequisites in your main .sdc:
# create_clock -name {sys_clk} -period 20.000 [get_ports {clk}]
# derive_pll_clocks
# derive_clock_uncertainty


# ---
# SCLK as primary clock (incoming from master)
# ---
# Set period to fastest expected master SCLK (25 MHz = 40 ns shown here).
create_clock -name {spi_sclk} -period 40.000 -waveform {0.000 20.000} \
    [get_ports {spi_sclk}]


# ---
# MOSI input delay (Mode 0 — sample on rising SCLK edge)
# ---
# -max = period - tSU_master    (40 - 5 = 35)
# -min = tH_master              (5)
set_input_delay -clock {spi_sclk} -max 35.000 [get_ports {spi_mosi}]
set_input_delay -clock {spi_sclk} -min  5.000 [get_ports {spi_mosi}]


# ---
# MISO output delay (Mode 0 — output changes on falling SCLK edge)
# ---
set_output_delay -clock {spi_sclk} -max  5.000 -fall [get_ports {spi_miso}]
set_output_delay -clock {spi_sclk} -min -3.000 -fall [get_ports {spi_miso}]


# ---
# CS_N — async chip select, false path
# ---
set_false_path -from [get_ports {spi_cs_n}]


# ---
# CDC: SCLK domain asynchronous to sys_clk
# ---
set_clock_groups -asynchronous \
    -group [get_clocks {spi_sclk}] \
    -group [get_clocks {sys_clk}]
