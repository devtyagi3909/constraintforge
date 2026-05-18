# ---
# Cmod A7-35T Master Constraint File (XDC)
# Device: Artix-7 XC7A35T-1CPG236C
# Board:  Digilent Cmod A7-35T (DIP-48 form factor)
# Vendor: Digilent
# Doc:    https://digilent.com/reference/programmable-logic/cmod-a7/reference-manual
# Schematic: https://digilent.com/reference/_media/reference/programmable-logic/cmod-a7/cmod_a7_sch.pdf
#
# FORM FACTOR: DIP-48 module — designed to plug into a solderless breadboard.
# This makes it extremely popular for standalone projects and course labs.
# I/O is limited compared to larger boards — 44 usable I/O pins total.
# All user I/O is at 3.3V (bank 34/35).
# ---


# ---
# CLOCK  —  12 MHz crystal oscillator
# ---
#
# The Cmod A7 uses a 12 MHz oscillator, NOT 100 MHz like most Digilent boards.
# Period = 1000/12 = 83.333 ns

set_property PACKAGE_PIN L17  [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 83.333 -name sys_clk -waveform {0.000 41.667} [get_ports clk]


# ---
# LEDs  —  2 user LEDs + 1 RGB LED (LD1=RGB, LD2=green)
# ---

## LD1 — Tri-color RGB LED
set_property PACKAGE_PIN A17  [get_ports led1_r]
set_property PACKAGE_PIN B16  [get_ports led1_g]
set_property PACKAGE_PIN B17  [get_ports led1_b]
set_property IOSTANDARD LVCMOS33 [get_ports led1_r]
set_property IOSTANDARD LVCMOS33 [get_ports led1_g]
set_property IOSTANDARD LVCMOS33 [get_ports led1_b]

## LD2 — Single green LED
set_property PACKAGE_PIN C16  [get_ports led2]
set_property IOSTANDARD LVCMOS33 [get_ports led2]
set_false_path -to [get_ports led2]
set_false_path -to [get_ports led1_r]
set_false_path -to [get_ports led1_g]
set_false_path -to [get_ports led1_b]


# ---
# PUSH BUTTONS  —  2 buttons, active high
# ---

set_property PACKAGE_PIN A18  [get_ports {btn[0]}]   ;# BTN0
set_property PACKAGE_PIN B18  [get_ports {btn[1]}]   ;# BTN1
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
set_false_path -from [get_ports {btn[*]}]


# ---
# USB-UART (via FTDI USB-to-Serial bridge, shared with JTAG)
# ---

set_property PACKAGE_PIN J18  [get_ports uart_txd]   ;# FPGA TX → PC
set_property PACKAGE_PIN J17  [get_ports uart_rxd]   ;# PC TX → FPGA
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# DIP-48 HEADER PINS  —  PIO1–PIO44 (general purpose I/O)
# ---
#
# The Cmod A7 exposes its I/O through two rows of header pins along the edge.
# These are labeled PIO1–PIO44 in the reference manual.
# Use these for breadboard connections, custom peripherals, etc.
#
# PIN MAP (from reference manual, verified against schematic):

set_property PACKAGE_PIN M3   [get_ports {pio[1]}]
set_property PACKAGE_PIN L3   [get_ports {pio[2]}]
set_property PACKAGE_PIN A16  [get_ports {pio[3]}]
set_property PACKAGE_PIN K3   [get_ports {pio[4]}]
set_property PACKAGE_PIN C15  [get_ports {pio[5]}]
set_property PACKAGE_PIN K16  [get_ports {pio[6]}]
set_property PACKAGE_PIN D15  [get_ports {pio[7]}]
set_property PACKAGE_PIN J18  [get_ports {pio[8]}]   ;# shared with uart_rxd
set_property PACKAGE_PIN J17  [get_ports {pio[9]}]   ;# shared with uart_txd
set_property PACKAGE_PIN J16  [get_ports {pio[10]}]
set_property PACKAGE_PIN J14  [get_ports {pio[11]}]
set_property PACKAGE_PIN G14  [get_ports {pio[12]}]
set_property PACKAGE_PIN H14  [get_ports {pio[13]}]
set_property PACKAGE_PIN H18  [get_ports {pio[14]}]
set_property PACKAGE_PIN H17  [get_ports {pio[15]}]
set_property PACKAGE_PIN G18  [get_ports {pio[16]}]
set_property PACKAGE_PIN G17  [get_ports {pio[17]}]
set_property PACKAGE_PIN G16  [get_ports {pio[18]}]
set_property PACKAGE_PIN H16  [get_ports {pio[19]}]
set_property PACKAGE_PIN F18  [get_ports {pio[20]}]
set_property PACKAGE_PIN F17  [get_ports {pio[21]}]
set_property PACKAGE_PIN F16  [get_ports {pio[22]}]
set_property PACKAGE_PIN F15  [get_ports {pio[23]}]
set_property PACKAGE_PIN E18  [get_ports {pio[24]}]
set_property PACKAGE_PIN E17  [get_ports {pio[25]}]
set_property PACKAGE_PIN E16  [get_ports {pio[26]}]
set_property PACKAGE_PIN E15  [get_ports {pio[27]}]
set_property PACKAGE_PIN D18  [get_ports {pio[28]}]
set_property PACKAGE_PIN D17  [get_ports {pio[29]}]
set_property PACKAGE_PIN D16  [get_ports {pio[30]}]
set_property PACKAGE_PIN D14  [get_ports {pio[31]}]
set_property PACKAGE_PIN C18  [get_ports {pio[32]}]
set_property PACKAGE_PIN C17  [get_ports {pio[33]}]
set_property PACKAGE_PIN B18  [get_ports {pio[34]}]   ;# shared with btn[1]
set_property PACKAGE_PIN A18  [get_ports {pio[35]}]   ;# shared with btn[0]
set_property PACKAGE_PIN B17  [get_ports {pio[36]}]   ;# shared with led1_b
set_property PACKAGE_PIN B16  [get_ports {pio[37]}]   ;# shared with led1_g
set_property PACKAGE_PIN A17  [get_ports {pio[38]}]   ;# shared with led1_r
set_property PACKAGE_PIN C16  [get_ports {pio[39]}]   ;# shared with led2
set_property PACKAGE_PIN K1   [get_ports {pio[40]}]
set_property PACKAGE_PIN M1   [get_ports {pio[41]}]
set_property PACKAGE_PIN N1   [get_ports {pio[42]}]
set_property PACKAGE_PIN N3   [get_ports {pio[43]}]
set_property PACKAGE_PIN P1   [get_ports {pio[44]}]

set_property IOSTANDARD LVCMOS33 [get_ports {pio[*]}]


# ---
# CONFIGURATION
# ---

set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
