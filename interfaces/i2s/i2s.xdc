# ---
# I2S AUDIO CONSTRAINTS  —  Xilinx Vivado (.xdc)
# ---
#
# I2S (Inter-IC Sound) is a synchronous serial audio interface.
# It uses 3 signals:
#   BCLK   : Bit clock (SCK) — clocks each audio bit
#   LRCLK  : Left/Right clock (WS) — selects left or right channel
#   SDATA  : Serial data (SD) — audio samples, MSB first
#
# TIMING MODEL:
#   I2S is SOURCE-SYNCHRONOUS from the master's perspective.
#   The master generates BCLK and LRCLK, and data transitions relative to BCLK.
#
#   When FPGA is I2S MASTER (generates clocks):
#     → BCLK and LRCLK are generated clocks (FPGA drives them)
#     → SDATA_TX output is constrained relative to generated BCLK
#     → SDATA_RX input from codec is constrained relative to generated BCLK
#
#   When FPGA is I2S SLAVE (receives clocks from external codec):
#     → BCLK is a primary clock (incoming)
#     → LRCLK is data (not a clock for constraint purposes)
#     → SDATA_RX constrained relative to incoming BCLK
#
# I2S TIMING PARAMETERS (from codec datasheet — e.g., SSM2603, CS4344, MAX98357):
#   tDSU  : Data setup time before BCLK edge (ns)
#   tDH   : Data hold  time after  BCLK edge (ns)
#   tCO   : Codec output delay after BCLK edge (ns)
#
# COMMON I2S CONFIGURATIONS:
#   44.1 kHz audio, 24-bit stereo:
#     LRCLK = 44,100 Hz
#     BCLK  = 44,100 × 24 × 2 = 2.1168 MHz  (period = 472.5 ns)
#   48 kHz audio, 32-bit stereo:
#     LRCLK = 48,000 Hz
#     BCLK  = 48,000 × 32 × 2 = 3.072 MHz   (period = 325.5 ns)
#   96 kHz audio, 32-bit stereo:
#     BCLK  = 96,000 × 32 × 2 = 6.144 MHz   (period = 162.8 ns)
#
# Reference: Cirrus Logic CS4344 Datasheet — I2S Timing Characteristics
# Reference: Analog Devices SSM2603 Datasheet
# Reference: Maxim MAX98357 Datasheet
# ---


# Pin Location and I/O Standard

## MCLK — Master clock to codec (typically 256× or 384× sample rate)
## e.g., 44.1 kHz × 256 = 11.2896 MHz ; 48 kHz × 256 = 12.288 MHz
set_property PACKAGE_PIN <MCLK_PIN>    [get_ports i2s_mclk]

## BCLK — Bit clock
set_property PACKAGE_PIN <BCLK_PIN>    [get_ports i2s_bclk]

## LRCLK — Left/Right (Word Select)
set_property PACKAGE_PIN <LRCLK_PIN>   [get_ports i2s_lrclk]

## SDATA_TX — Serial data output from FPGA to codec DAC input
set_property PACKAGE_PIN <SDTX_PIN>    [get_ports i2s_sdata_tx]

## SDATA_RX — Serial data input from codec ADC output to FPGA
set_property PACKAGE_PIN <SDRX_PIN>    [get_ports i2s_sdata_rx]

set_property IOSTANDARD LVCMOS33 [get_ports i2s_mclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_bclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_sdata_tx]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_sdata_rx]


# ---
# ---
#
# When the FPGA generates BCLK, it's an output — define it as a generated clock.
# BCLK is derived from your sys_clk via a divider in RTL.
#
# Example: sys_clk = 100 MHz, target BCLK = 3.072 MHz
#   Divider = 100,000,000 / 3,072,000 = 32.55 → round to 32 (3.125 MHz, close enough)
#   Actual BCLK = 100 MHz / 32 = 3.125 MHz
#
create_generated_clock \
    -name i2s_bclk_gen \
    -source [get_ports clk] \
    -divide_by 32 \
    [get_ports i2s_bclk]
#   Adjust -divide_by to match your RTL divider ratio

# MCLK — typically 8× BCLK = sys_clk / 4
create_generated_clock \
    -name i2s_mclk_gen \
    -source [get_ports clk] \
    -divide_by 8 \
    [get_ports i2s_mclk]


# SDATA_TX output — data changes after falling BCLK edge (I2S standard)
# Codec requires: tDSU = 10 ns setup, tDH = 0 ns hold (SSM2603 typical)
set_output_delay -clock i2s_bclk_gen -clock_fall -max  10.0 [get_ports i2s_sdata_tx]
set_output_delay -clock i2s_bclk_gen -clock_fall -min   0.0 [get_ports i2s_sdata_tx]

# LRCLK output — treated same as SDATA (changes on BCLK falling edge)
set_output_delay -clock i2s_bclk_gen -clock_fall -max  10.0 [get_ports i2s_lrclk]
set_output_delay -clock i2s_bclk_gen -clock_fall -min   0.0 [get_ports i2s_lrclk]

# SDATA_RX input — codec presents data after rising BCLK edge
# tCO_max = 15 ns (codec output valid within 15 ns after BCLK rising edge)
# tCO_min =  0 ns (codec output valid immediately after BCLK rising edge)
set_input_delay -clock i2s_bclk_gen -max 15.0 [get_ports i2s_sdata_rx]
set_input_delay -clock i2s_bclk_gen -min  0.0 [get_ports i2s_sdata_rx]


# ---
# ---
#
# Uncomment this section if the codec is the I2S master (provides BCLK/LRCLK).
# Comment out Section 2a above.
#
# Codec BCLK rate: 3.072 MHz → period = 325.5 ns
# create_clock -period 325.5 -name i2s_bclk [get_ports i2s_bclk]
#
# SDATA_RX input — data valid before rising BCLK (I2S slave samples on rising)
# set_input_delay -clock i2s_bclk -max 290.0 [get_ports i2s_sdata_rx]
# set_input_delay -clock i2s_bclk -min  10.0 [get_ports i2s_sdata_rx]
#
# SDATA_TX output — data changes on falling BCLK edge (before next rising edge)
# set_output_delay -clock i2s_bclk -clock_fall -max 10.0 [get_ports i2s_sdata_tx]
# set_output_delay -clock i2s_bclk -clock_fall -min  0.0 [get_ports i2s_sdata_tx]
#
# LRCLK as input (codec drives it):
# set_false_path -from [get_ports i2s_lrclk]  ;# LRCLK is data, not a timing ref
#
# CDC between i2s_bclk domain and sys_clk domain:
# set_clock_groups -asynchronous \
#     -group [get_clocks i2s_bclk] \
#     -group [get_clocks sys_clk]


# ---
# AUDIO SAMPLE RATE REFERENCE TABLE
# System Clock: 100 MHz
#
# Sample Rate | BCLK (24-bit) | BCLK div | MCLK (256x) | MCLK div
# ------------|---------------|----------|-------------|----------
# 44.1  kHz   | 2.1168  MHz   |   47.3   | 11.2896 MHz |   8.86
# 48    kHz   | 2.304   MHz   |   43.4   | 12.288  MHz |   8.14
# 96    kHz   | 6.144   MHz   |   16.3   | 24.576  MHz |   4.07
# 192   kHz   | 12.288  MHz   |    8.1   | 49.152  MHz |   2.03
#
# Because 44.1 kHz and 48 kHz have irrational dividers from 100 MHz,
# consider using a 22.5792 MHz or 24.576 MHz reference PLL for exact rates.
