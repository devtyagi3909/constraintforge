# SPI master constraints — Xilinx Vivado (.xdc)
#
# SPI is source-synchronous: the master (your FPGA) drives SCLK alongside data.
# MOSI and MISO timing is measured relative to SCLK edges, not your system clock.
#
# The constraint approach:
#   1. Define SCLK as a generated clock on the output port
#   2. set_output_delay for MOSI relative to that generated clock
#   3. set_input_delay  for MISO relative to that generated clock
#   4. set_false_path on CS_N (it toggles far from SCLK edges)
#
# Values come from your slave device's datasheet:
#   tSU  — slave setup time before SCLK edge  → output_delay -max
#   tH   — slave hold time after SCLK edge    → output_delay -min (negative)
#   tCO_max — slave output delay worst case   → input_delay -max
#   tCO_min — slave output delay best case    → input_delay -min

# ---
# Pins — replace with actual package pins
set_property PACKAGE_PIN <SCLK_PIN>  [get_ports spi_sclk]
set_property PACKAGE_PIN <MOSI_PIN>  [get_ports spi_mosi]
set_property PACKAGE_PIN <MISO_PIN>  [get_ports spi_miso]
set_property PACKAGE_PIN <CS_N_PIN>  [get_ports spi_cs_n]

set_property IOSTANDARD LVCMOS33 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_cs_n]

# ---
# Generated clock on SCLK output
# -divide_by should match your RTL's clock divider ratio
# e.g. sys_clk=100MHz, divide_by=4 → SCLK=25MHz
create_generated_clock \
    -name spi_sclk_gen \
    -source [get_ports clk] \
    -divide_by 4 \
    [get_ports spi_sclk]

# ---
# MOSI output delay (SPI Mode 0: data valid before rising SCLK)
# Replace 5.0 with slave tSU, replace -2.0 with -(slave tH)
set_output_delay -clock spi_sclk_gen -max  5.0 [get_ports spi_mosi]
set_output_delay -clock spi_sclk_gen -min -2.0 [get_ports spi_mosi]

# ---
# MISO input delay (slave drives data after SCLK edge)
# Replace 8.0 with slave tCO_max, 1.0 with slave tCO_min
set_input_delay -clock spi_sclk_gen -max 8.0 [get_ports spi_miso]
set_input_delay -clock spi_sclk_gen -min 1.0 [get_ports spi_miso]

# ---
# CS_N — false path (asserts before first SCLK, deasserts after last)
set_false_path -to [get_ports spi_cs_n]

# Multiple chip selects:
# set_false_path -to [get_ports {spi_cs_n[*]}]
