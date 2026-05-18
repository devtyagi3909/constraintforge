# ---
# Basys 3 Master Constraint File (XDC)
# Device: Artix-7 XC7A35T-1CPG236C
# Board:  Digilent Basys 3
# ---
#


# ---
# CLOCK
# ---

## 100 MHz System Clock
## On-board crystal oscillator. Single-ended, bank 34, VCCO = 3.3V
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]


# ---
# SWITCHES (SW)  —  16 slide switches, active high
# ---

## SW0 — SW15: Active high, connected through resistors to protect FPGA
## Uncomment and rename ports to match your design

set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]

set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]

set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]

set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]

set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]

set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]

set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]

set_property PACKAGE_PIN V2  [get_ports {sw[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]

set_property PACKAGE_PIN T3  [get_ports {sw[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]

set_property PACKAGE_PIN T2  [get_ports {sw[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]

set_property PACKAGE_PIN R3  [get_ports {sw[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]

set_property PACKAGE_PIN W2  [get_ports {sw[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]

set_property PACKAGE_PIN U1  [get_ports {sw[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]

set_property PACKAGE_PIN T1  [get_ports {sw[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]

set_property PACKAGE_PIN R2  [get_ports {sw[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]


# ---
# LEDs  —  16 general-purpose LEDs, active high
# ---

set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]

set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]

set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]

set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]

set_property PACKAGE_PIN V13 [get_ports {led[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]

set_property PACKAGE_PIN V3  [get_ports {led[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]

set_property PACKAGE_PIN W3  [get_ports {led[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]

set_property PACKAGE_PIN U3  [get_ports {led[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]

set_property PACKAGE_PIN P3  [get_ports {led[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]

set_property PACKAGE_PIN N3  [get_ports {led[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]

set_property PACKAGE_PIN P1  [get_ports {led[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]

set_property PACKAGE_PIN L1  [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]


# ---
# 7-SEGMENT DISPLAYS  —  4-digit, common anode, active low
# ---
#
# Architecture: 4 displays share 7 segment pins. A separate 4-bit enable
# (active low) selects which digit is illuminated. Multiplexing at ~1 kHz
# in your RTL creates the appearance of all 4 digits lighting simultaneously.

## Segments (active low — drive '0' to turn segment ON)
set_property PACKAGE_PIN W7  [get_ports seg_ca]     ;# Segment A
set_property PACKAGE_PIN W6  [get_ports seg_cb]     ;# Segment B
set_property PACKAGE_PIN U8  [get_ports seg_cc]     ;# Segment C
set_property PACKAGE_PIN V8  [get_ports seg_cd]     ;# Segment D
set_property PACKAGE_PIN U5  [get_ports seg_ce]     ;# Segment E
set_property PACKAGE_PIN V5  [get_ports seg_cf]     ;# Segment F
set_property PACKAGE_PIN U7  [get_ports seg_cg]     ;# Segment G
set_property PACKAGE_PIN V7  [get_ports seg_dp]     ;# Decimal Point

set_property IOSTANDARD LVCMOS33 [get_ports seg_ca]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cb]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cc]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cd]
set_property IOSTANDARD LVCMOS33 [get_ports seg_ce]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cf]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cg]
set_property IOSTANDARD LVCMOS33 [get_ports seg_dp]

## Digit enables (active low — drive '0' to SELECT this digit)
set_property PACKAGE_PIN U2  [get_ports {an[0]}]   ;# Digit 0 (rightmost)
set_property PACKAGE_PIN U4  [get_ports {an[1]}]   ;# Digit 1
set_property PACKAGE_PIN V4  [get_ports {an[2]}]   ;# Digit 2
set_property PACKAGE_PIN W4  [get_ports {an[3]}]   ;# Digit 3 (leftmost)

set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


# ---
# PUSH BUTTONS  —  5 buttons (BTNC, BTNU, BTNL, BTNR, BTND), active high
# ---

set_property PACKAGE_PIN U18 [get_ports btn_c]     ;# Center button
set_property PACKAGE_PIN T18 [get_ports btn_u]     ;# Up button
set_property PACKAGE_PIN W19 [get_ports btn_l]     ;# Left button
set_property PACKAGE_PIN T17 [get_ports btn_r]     ;# Right button
set_property PACKAGE_PIN U17 [get_ports btn_d]     ;# Down button

set_property IOSTANDARD LVCMOS33 [get_ports btn_c]
set_property IOSTANDARD LVCMOS33 [get_ports btn_u]
set_property IOSTANDARD LVCMOS33 [get_ports btn_l]
set_property IOSTANDARD LVCMOS33 [get_ports btn_r]
set_property IOSTANDARD LVCMOS33 [get_ports btn_d]

## Buttons are async → false path (they're debounced in RTL, not timing critical)
set_false_path -from [get_ports btn_c]
set_false_path -from [get_ports btn_u]
set_false_path -from [get_ports btn_l]
set_false_path -from [get_ports btn_r]
set_false_path -from [get_ports btn_d]


# ---
# USB-UART (via Digilent Adept)
# ---
#
# The Basys3 has a FTDI USB-UART bridge chip. These are the FPGA-side pins.
# Baud rates up to 921600 work reliably.

set_property PACKAGE_PIN B18 [get_ports uart_txd]   ;# FPGA TX → PC RX
set_property PACKAGE_PIN A18 [get_ports uart_rxd]   ;# PC TX → FPGA RX
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]

set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# VGA OUTPUT  —  4-bit R, 4-bit G, 4-bit B + HSync, VSync
# ---

## Red channel (4 bits)
set_property PACKAGE_PIN G19 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN H19 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN J19 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN N19 [get_ports {vga_r[3]}]

## Green channel (4 bits)
set_property PACKAGE_PIN J17 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN H17 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN G17 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN D17 [get_ports {vga_g[3]}]

## Blue channel (4 bits)
set_property PACKAGE_PIN N18 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN L18 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN K18 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN J18 [get_ports {vga_b[3]}]

## Sync signals
set_property PACKAGE_PIN P19 [get_ports vga_hs]
set_property PACKAGE_PIN R19 [get_ports vga_vs]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hs]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vs]


# ---
# PMOD CONNECTORS  —  JA, JB, JC, JXADC
# ---
#
# Each PMOD connector has 8 data pins (4 top row, 4 bottom row), VCC, and GND.
# JXADC pins are connected to the FPGA's differential I/O capable pins.

## JA (12-pin Pmod, standard)
set_property PACKAGE_PIN J1  [get_ports {ja[0]}]   ;# JA1 (row 1, pin 1)
set_property PACKAGE_PIN L2  [get_ports {ja[1]}]   ;# JA2
set_property PACKAGE_PIN J2  [get_ports {ja[2]}]   ;# JA3
set_property PACKAGE_PIN G2  [get_ports {ja[3]}]   ;# JA4
set_property PACKAGE_PIN H1  [get_ports {ja[4]}]   ;# JA7 (row 2, pin 1)
set_property PACKAGE_PIN K2  [get_ports {ja[5]}]   ;# JA8
set_property PACKAGE_PIN H2  [get_ports {ja[6]}]   ;# JA9
set_property PACKAGE_PIN G3  [get_ports {ja[7]}]   ;# JA10

set_property IOSTANDARD LVCMOS33 [get_ports {ja[*]}]

## JB (12-pin Pmod)
set_property PACKAGE_PIN A14 [get_ports {jb[0]}]
set_property PACKAGE_PIN A16 [get_ports {jb[1]}]
set_property PACKAGE_PIN B15 [get_ports {jb[2]}]
set_property PACKAGE_PIN B16 [get_ports {jb[3]}]
set_property PACKAGE_PIN A15 [get_ports {jb[4]}]
set_property PACKAGE_PIN A17 [get_ports {jb[5]}]
set_property PACKAGE_PIN C15 [get_ports {jb[6]}]
set_property PACKAGE_PIN C16 [get_ports {jb[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {jb[*]}]


# ---
# CONFIGURATION / MISC
# ---

## Configuration bank voltage — required for correct operation
## CFGBVS = VCCO means the configuration bank uses VCCO (3.3V in this case)
set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
