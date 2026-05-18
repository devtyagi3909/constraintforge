# ---
# SPI MASTER CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
#
# Source-synchronous interface. The FPGA drives SCLK and times MOSI/MISO
# relative to it. See interfaces/spi/spi-master.xdc for full theory.
#
# ---

set_time_format -unit ns -decimal_places 3

# Prerequisite: primary clock and PLL clocks must be defined in your main .sdc:
# create_clock -name {sys_clk} -period 10.000 [get_ports {clk}]
# derive_pll_clocks
# derive_clock_uncertainty


# ---
# Generated clock on SCLK output pin
# ---
#
# SCLK is derived from sys_clk by a divider in your RTL.
# -divide_by 4 means SCLK = sys_clk / 4.
# Adjust -divide_by to match your actual divider ratio.
#
create_generated_clock \
    -name {spi_sclk_gen} \
    -source [get_ports {clk}] \
    -divide_by 4 \
    [get_ports {spi_sclk}]


# ---
# Output delay for MOSI
# ---
#
# These values must match your slave device's datasheet:
#   -max = slave's setup requirement (tSU)
#   -min = negative of slave's hold requirement (-tH)
#
set_output_delay -clock {spi_sclk_gen} -max  5.000 [get_ports {spi_mosi}]
set_output_delay -clock {spi_sclk_gen} -min -2.000 [get_ports {spi_mosi}]


# ---
# Input delay for MISO
# ---
#
#   -max = slave's worst-case output delay (tCO_max)
#   -min = slave's best-case output delay  (tCO_min)
#
set_input_delay -clock {spi_sclk_gen} -max  8.000 [get_ports {spi_miso}]
set_input_delay -clock {spi_sclk_gen} -min  1.000 [get_ports {spi_miso}]


# ---
# Chip select — false path (toggled far from SCLK edges)
# ---
set_false_path -to [get_ports {spi_cs_n}]
