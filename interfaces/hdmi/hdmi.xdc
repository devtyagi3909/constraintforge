# ---
# HDMI OUTPUT CONSTRAINTS (TMDS)  —  Xilinx Vivado (.xdc)
# ---
#
# HDMI uses TMDS (Transition-Minimized Differential Signaling) at the
# physical layer. Each HDMI link has:
#   - 3 TMDS data channels  (D0, D1, D2) — each carrying 10-bit encoded data
#   - 1 TMDS clock channel              — pixel clock (or 5x pixel clock for SERDES)
#
# FPGA HDMI TRANSMITTER ARCHITECTURE:
#   The most common implementation on 7-Series FPGAs uses OSERDESE2 (output
#   serializer) running at 5x the pixel clock to serialize 10-bit TMDS words
#   into a DDR bitstream at (pixel_clock × 5) baud rate.
#
#   Example: 1080p60 needs 148.5 MHz pixel clock
#     → SERDES bit clock = 148.5 × 5 = 742.5 MHz  (must be within device speed)
#     → TMDS channel rate = 742.5 Mb/s per channel
#
# COMMON PIXEL CLOCKS (from CEA-861 standard):
#   640×480@60Hz    →  25.175 MHz  → 125.875 MHz SERDES
#   800×600@60Hz    →  40.000 MHz  → 200.000 MHz SERDES
#   1280×720@60Hz   →  74.250 MHz  → 371.250 MHz SERDES
#   1920×1080@60Hz  → 148.500 MHz  → 742.500 MHz SERDES
#
# REQUIRED RTL COMPONENTS:
#   1. MMCM: generates pixel_clk and pixel_clk_5x from sys_clk
#   2. TMDS encoder: RGB → 10-bit TMDS symbols per channel
#   3. OSERDESE2: 10→1 serialization (or 2× OSERDESE2 for 10-bit)
#   4. OBUFDS: differential output buffer for each TMDS pair
#
# Reference: CEA-861-F — DTV Profile for Uncompressed High Speed Digital Interfaces
# Reference: HDMI 1.4 Specification — TMDS Electrical Specification
# ---


# Pixel clock and SERDES clock (from MMCM)
#
# These are generated clocks from your MMCM. Define the MMCM primary clock
# in primary-clock.xdc first, then add generated clocks here.
#
# The primary input clock to MMCM (e.g., 100 MHz system clock):
# create_clock -period 10.0 -name sys_clk [get_ports clk]   ← in primary-clock.xdc
#
# MMCM output 0: pixel clock (e.g., 74.25 MHz for 720p)
create_generated_clock \
    -name pixel_clk \
    -source [get_pins u_mmcm_hdmi/CLKIN1] \
    -multiply_by 297 \
    -divide_by 400 \
    [get_pins u_mmcm_hdmi/CLKOUT0]
#   ^^^ 100 MHz × 297/400 = 74.25 MHz (720p pixel clock)
#   Adjust multiply/divide for your target resolution.

# MMCM output 1: 5× pixel clock for SERDES (e.g., 371.25 MHz for 720p)
create_generated_clock \
    -name pixel_clk_5x \
    -source [get_pins u_mmcm_hdmi/CLKIN1] \
    -multiply_by 297 \
    -divide_by 80 \
    [get_pins u_mmcm_hdmi/CLKOUT1]
#   ^^^ 100 MHz × 297/80 = 371.25 MHz


# Pin Location — TMDS Differential Pairs
#
# HDMI pins MUST be in a bank with:
#   - VCCO = 3.3V for TMDS signaling on 7-Series (LVDS_25 requires 2.5V bank)
#   - Use TMDS_33 standard for 3.3V banks (Artix-7, Kintex-7)
#   - High-speed column I/O (HR or HP banks with MGT access preferred)
#
# Replace <PIN> with actual board pins. Check board schematic.
# Pins come in P/N pairs — always place them on the same differential pair.

## TMDS Clock pair
set_property PACKAGE_PIN <CLK_P>  [get_ports tmds_clk_p]
set_property PACKAGE_PIN <CLK_N>  [get_ports tmds_clk_n]

## TMDS Data channel 0 (Blue / CB)
set_property PACKAGE_PIN <D0_P>   [get_ports {tmds_data_p[0]}]
set_property PACKAGE_PIN <D0_N>   [get_ports {tmds_data_n[0]}]

## TMDS Data channel 1 (Green / Y)
set_property PACKAGE_PIN <D1_P>   [get_ports {tmds_data_p[1]}]
set_property PACKAGE_PIN <D1_N>   [get_ports {tmds_data_n[1]}]

## TMDS Data channel 2 (Red / CR)
set_property PACKAGE_PIN <D2_P>   [get_ports {tmds_data_p[2]}]
set_property PACKAGE_PIN <D2_N>   [get_ports {tmds_data_n[2]}]


# I/O Standards for TMDS
#
# TMDS_33: Use for 3.3V I/O banks (Artix-7, Kintex-7 HR banks)
#          Pre-emphasizes the differential output for TMDS electrical compliance.
# LVDS_25: Use for 2.5V I/O banks (requires VCCO=2.5V — confirm on your board)
#
# Most dev boards (Basys3, Arty, Nexys) use 3.3V TMDS → TMDS_33.
set_property IOSTANDARD TMDS_33 [get_ports tmds_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports tmds_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_p[*]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_n[*]}]


# Output Timing for TMDS
#
# TMDS is source-synchronous: the receiver recovers the clock from the TMDS
# clock channel. The transmitter (your FPGA) drives data and clock together.
#
# For OSERDESE2-based TMDS output, the serializer handles all timing internally.
# You do NOT need set_output_delay on TMDS pins because:
#   1. The clock is embedded in the TMDS clock channel
#   2. The receiver uses CDR (clock/data recovery), not set_output_delay
#   3. Vivado cannot time to an external CDR receiver
#
# Apply false path to TMDS outputs — timing is guaranteed by the SERDES
# architecture and TMDS electrical spec, not by Vivado's timing analysis.
set_false_path -to [get_ports {tmds_data_p[*]}]
set_false_path -to [get_ports {tmds_data_n[*]}]
set_false_path -to [get_ports tmds_clk_p]
set_false_path -to [get_ports tmds_clk_n]


# Clock domain isolation
#
# The pixel_clk and pixel_clk_5x domains should be treated as a group.
# They are synchronous to each other (5x relationship), but async to sys_clk.
set_clock_groups -asynchronous \
    -group [get_clocks sys_clk] \
    -group [get_clocks -include_generated_clocks pixel_clk]


# ---
# BOARD EXAMPLES:
#
#   Basys3  → Uses Pmod HDMI connector (Pmod HDMI adapter, e.g., Digilent 410-379)
#              Pins depend on which Pmod header you plug it into.
#
#   Arty A7 → No on-board HDMI. Use Pmod HDMI adapter on JB/JC (diff-capable).
#
#   Nexys4 / Nexys A7 → Has dedicated HDMI port.
#              CLK_P = V17, CLK_N = U17
#              D0: T19/U19, D1: W18/V18, D2: AA18/AB18
#              (verify against your specific Nexys revision schematic)
