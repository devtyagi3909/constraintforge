# ---
# SPI SLAVE CONSTRAINTS  —  Xilinx Vivado (.xdc)
# ---
#
# When the FPGA is a SPI SLAVE, it does NOT generate the clock —
# the external master drives SCLK. This fundamentally changes the constraint
# approach compared to SPI master:
#
#   SPI MASTER (FPGA drives SCLK):
#     → create_generated_clock on SCLK output port
#     → set_output_delay for MOSI relative to generated SCLK
#     → set_input_delay  for MISO relative to generated SCLK
#
#   SPI SLAVE (external master drives SCLK):
#     → create_clock on SCLK INPUT port  (it's a primary clock coming in)
#     → set_input_delay  for MOSI relative to incoming SCLK
#     → set_output_delay for MISO relative to incoming SCLK
#     → CDC: SCLK domain → sys_clk domain (set_clock_groups)
#
# SPI MODES (CPOL/CPHA):
#   Mode 0 (CPOL=0, CPHA=0): Sample on rising  edge, shift on falling edge
#   Mode 1 (CPOL=0, CPHA=1): Sample on falling edge, shift on rising  edge
#   Mode 2 (CPOL=1, CPHA=0): Sample on falling edge, shift on rising  edge
#   Mode 3 (CPOL=1, CPHA=1): Sample on rising  edge, shift on falling edge
#
# This template covers Mode 0 (most common). Adjust -clock_fall for other modes.
#
# KEY CHALLENGE: SCLK from an external master can be slow (< 1 MHz) or fast
# (up to 50 MHz+). The FPGA's sys_clk is typically much faster (100-200 MHz).
# The SCLK domain and sys_clk domain are ASYNCHRONOUS → need CDC handling.
#
# Reference: SPI Bus Specification (Motorola)
# ---


# Pin Location and I/O Standard

set_property PACKAGE_PIN <SCLK_PIN>  [get_ports spi_sclk]    ;# Input — from master
set_property PACKAGE_PIN <MOSI_PIN>  [get_ports spi_mosi]    ;# Input — master drives
set_property PACKAGE_PIN <MISO_PIN>  [get_ports spi_miso]    ;# Output — slave drives
set_property PACKAGE_PIN <CS_N_PIN>  [get_ports spi_cs_n]    ;# Input — chip select

set_property IOSTANDARD LVCMOS33 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_cs_n]

# MISO drive strength — fast slew for clean edges, especially at higher SCLK rates
set_property DRIVE 8    [get_ports spi_miso]
set_property SLEW  FAST [get_ports spi_miso]


# SCLK as Primary Clock (incoming from external master)
#
# SCLK enters the FPGA from outside — it is a primary clock for this design.
# Define its period based on the FASTEST expected master SCLK rate.
#
# -period 40.0 = 25 MHz SCLK maximum (adjust to your system's worst case)
# Common SCLK rates and their periods:
#   1 MHz  → 1000.0 ns
#   10 MHz →  100.0 ns
#   25 MHz →   40.0 ns
#   50 MHz →   20.0 ns
#
# Use the FASTEST clock your master will ever drive.
# If the period is too long (slow), timing will appear to pass but
# may fail at higher speeds in real hardware.
#
create_clock -period 40.0 -name spi_sclk [get_ports spi_sclk]


# MOSI Input Delay (Master → Slave, Mode 0)
#
# In Mode 0: master changes MOSI on the falling edge of SCLK.
#            Slave samples MOSI on the rising edge of SCLK.
#
# From the SPI master's datasheet (or protocol spec):
#   tSU = MOSI setup time before rising SCLK edge
#   tH  = MOSI hold  time after  rising SCLK edge
#
# Typical values for a well-designed master (e.g., microcontroller SPI):
#   tSU ≈ 5 ns  (data valid 5 ns before SCLK rising edge)
#   tH  ≈ 5 ns  (data held 5 ns after SCLK rising edge)
#
# set_input_delay -max = period - tSU  (data arrives late — worst case for setup)
# set_input_delay -min = tH            (data arrives early — worst case for hold)
#
set_input_delay -clock spi_sclk -max 35.0 [get_ports spi_mosi]
set_input_delay -clock spi_sclk -min  5.0 [get_ports spi_mosi]
#               ^^^^^^^^                   40 ns period - 5 ns tSU = 35 ns max


# MISO Output Delay (Slave → Master, Mode 0)
#
# In Mode 0: slave changes MISO on the falling edge of SCLK (output shifts out).
#            Master samples MISO on the rising edge of SCLK.
#
# From the SPI master/standard's datasheet:
#   tSU_master = master's MISO setup requirement before rising SCLK
#   tH_master  = master's MISO hold requirement after rising SCLK
#
# Use -clock_fall because the slave output changes on the FALLING edge of SCLK.
#
# Typical values:
#   tSU_master ≈ 5 ns
#   tH_master  ≈ 3 ns
#
set_output_delay -clock spi_sclk -clock_fall -max  5.0 [get_ports spi_miso]
set_output_delay -clock spi_sclk -clock_fall -min -3.0 [get_ports spi_miso]


# CS_N — False Path (async chip select)
#
# CS_N asserts/deasserts long before/after SCLK edges. No timing constraint.
# Your RTL should synchronize CS_N into the sys_clk domain.
#
set_false_path -from [get_ports spi_cs_n]


# CDC — SCLK domain to sys_clk domain
#
# SCLK comes from an external master and is asynchronous to your sys_clk.
# Any data captured on the SCLK domain that feeds into sys_clk logic needs:
#   RTL: async FIFO or 2-FF synchronizer
#   XDC: set_clock_groups -asynchronous
#
set_clock_groups -asynchronous \
    -group [get_clocks spi_sclk] \
    -group [get_clocks sys_clk]


# ---
#   [ ] Replace <*_PIN> placeholders with actual package pins
#   [ ] Set create_clock period to match maximum master SCLK rate
#   [ ] Adjust set_input_delay values from master device datasheet
#   [ ] Adjust set_output_delay values from master device datasheet
#   [ ] RTL has 2-FF synchronizer or async FIFO for SCLK→sys_clk crossing
#   [ ] SPI mode (CPOL/CPHA) matches — use -clock_fall appropriately
