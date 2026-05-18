# ---
# ZCU104 Master Constraint File (XDC)
# Device: Zynq UltraScale+ MPSoC XCZU7EV-2FFVC1156
# Board:  Xilinx ZCU104 Evaluation Kit
# Doc:    https://docs.amd.com/r/en-US/ug1267-zcu104-eval-bd
# ---
#
# ZCU104 is a Zynq MPSoC board. PL (Programmable Logic) clocks are
# typically sourced from the PS (Processing System) FCLK outputs or from
# on-board oscillators. Use PS IP in Vivado to configure FCLK frequencies.
#
# I/O VOLTAGE NOTE: ZCU104 PL I/O banks run at 1.8V (LVCMOS18) by default.
# Some banks run at 3.3V for Arduino/Pmod compatibility. CHECK YOUR BANK!


# ---
# PL CLOCKS (from on-board oscillators to PL logic)
# ---

## 300 MHz differential reference clock (PL bank 66, LVDS)
set_property PACKAGE_PIN E23 [get_ports clk_300_p]
set_property PACKAGE_PIN D23 [get_ports clk_300_n]
set_property IOSTANDARD LVDS [get_ports clk_300_p]
set_property IOSTANDARD LVDS [get_ports clk_300_n]
create_clock -period 3.333 -name clk_300mhz [get_ports clk_300_p]

## 125 MHz single-ended PL clock (bank 65)
set_property PACKAGE_PIN G21 [get_ports clk_125]
set_property IOSTANDARD LVCMOS18 [get_ports clk_125]
create_clock -period 8.000 -name clk_125mhz [get_ports clk_125]


# ---
# USER LEDs  —  4 LEDs, active high, 1.8V bank
# ---

set_property PACKAGE_PIN D5  [get_ports {led[0]}]
set_property PACKAGE_PIN D6  [get_ports {led[1]}]
set_property PACKAGE_PIN A5  [get_ports {led[2]}]
set_property PACKAGE_PIN B5  [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[*]}]


# ---
# PUSH BUTTONS  —  6 push buttons (GPIO), active high, 1.8V
# ---

set_property PACKAGE_PIN B4  [get_ports {btn[0]}]    ;# SW19 — N
set_property PACKAGE_PIN C4  [get_ports {btn[1]}]    ;# SW20 — S
set_property PACKAGE_PIN B3  [get_ports {btn[2]}]    ;# SW21 — W
set_property PACKAGE_PIN A3  [get_ports {btn[3]}]    ;# SW22 — E
set_property PACKAGE_PIN A4  [get_ports {btn[4]}]    ;# SW23 — Center
set_property IOSTANDARD LVCMOS18 [get_ports {btn[*]}]
set_false_path -from [get_ports {btn[*]}]


# ---
# SLIDE SWITCHES  —  8 DIP switches, active high, 1.8V
# ---

set_property PACKAGE_PIN E4  [get_ports {sw[0]}]
set_property PACKAGE_PIN D4  [get_ports {sw[1]}]
set_property PACKAGE_PIN F5  [get_ports {sw[2]}]
set_property PACKAGE_PIN F4  [get_ports {sw[3]}]
set_property PACKAGE_PIN E3  [get_ports {sw[4]}]
set_property PACKAGE_PIN E2  [get_ports {sw[5]}]
set_property PACKAGE_PIN F3  [get_ports {sw[6]}]
set_property PACKAGE_PIN F2  [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[*]}]


# ---
# UART (via USB-UART bridge, PL side)
# ---

set_property PACKAGE_PIN A20 [get_ports uart_txd]
set_property PACKAGE_PIN C19 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS18 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS18 [get_ports uart_rxd]
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# PMOD CONNECTORS  —  J55, J87 (1.8V LVCMOS)
# ---

## J55 (PMOD0)
set_property PACKAGE_PIN H12 [get_ports {pmod0[0]}]
set_property PACKAGE_PIN G12 [get_ports {pmod0[1]}]
set_property PACKAGE_PIN F12 [get_ports {pmod0[2]}]
set_property PACKAGE_PIN E12 [get_ports {pmod0[3]}]
set_property PACKAGE_PIN D11 [get_ports {pmod0[4]}]
set_property PACKAGE_PIN C11 [get_ports {pmod0[5]}]
set_property PACKAGE_PIN B11 [get_ports {pmod0[6]}]
set_property PACKAGE_PIN A11 [get_ports {pmod0[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0[*]}]


# ---
# CONFIGURATION
# ---

## ZCU104 uses VCCO bank voltage — 1.8V for most PL banks
set_property CFGBVS GND         [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
