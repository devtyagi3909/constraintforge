# ---
# Arty A7-100T Master Constraint File (XDC)
# Device: Artix-7 XC7A100T-1CSG324C
# Board:  Digilent Arty A7-100T
# ---
#


# ---
# CLOCK
# ---

## 100 MHz System Clock (E3 — Bank 35, VCCO = 3.3V)
set_property PACKAGE_PIN E3  [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]


# ---
# RESET  —  Active-low push button (CPU RESET, BTN0 on board)
# ---

set_property PACKAGE_PIN C2  [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_false_path -from [get_ports rst_n]


# ---
# LEDs  —  4 general-purpose LEDs (LD0–LD3), active high
# ---

set_property PACKAGE_PIN H5  [get_ports {led[0]}]    ;# LD0 Green
set_property PACKAGE_PIN J5  [get_ports {led[1]}]    ;# LD1 Green
set_property PACKAGE_PIN T9  [get_ports {led[2]}]    ;# LD2 Green
set_property PACKAGE_PIN T10 [get_ports {led[3]}]    ;# LD3 Green
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]


# ---
# RGB LEDs  —  4 tri-color LEDs (LD4–LD7), active HIGH for each color
# ---

## LD4
set_property PACKAGE_PIN G6  [get_ports {led4_r}]
set_property PACKAGE_PIN F6  [get_ports {led4_g}]
set_property PACKAGE_PIN E1  [get_ports {led4_b}]

## LD5
set_property PACKAGE_PIN G3  [get_ports {led5_r}]
set_property PACKAGE_PIN J4  [get_ports {led5_g}]
set_property PACKAGE_PIN G4  [get_ports {led5_b}]

## LD6
set_property PACKAGE_PIN J3  [get_ports {led6_r}]
set_property PACKAGE_PIN J2  [get_ports {led6_g}]
set_property PACKAGE_PIN H4  [get_ports {led6_b}]

## LD7
set_property PACKAGE_PIN K1  [get_ports {led7_r}]
set_property PACKAGE_PIN H6  [get_ports {led7_g}]
set_property PACKAGE_PIN K2  [get_ports {led7_b}]

set_property IOSTANDARD LVCMOS33 [get_ports led4_r]
set_property IOSTANDARD LVCMOS33 [get_ports led4_g]
set_property IOSTANDARD LVCMOS33 [get_ports led4_b]
set_property IOSTANDARD LVCMOS33 [get_ports led5_r]
set_property IOSTANDARD LVCMOS33 [get_ports led5_g]
set_property IOSTANDARD LVCMOS33 [get_ports led5_b]
set_property IOSTANDARD LVCMOS33 [get_ports led6_r]
set_property IOSTANDARD LVCMOS33 [get_ports led6_g]
set_property IOSTANDARD LVCMOS33 [get_ports led6_b]
set_property IOSTANDARD LVCMOS33 [get_ports led7_r]
set_property IOSTANDARD LVCMOS33 [get_ports led7_g]
set_property IOSTANDARD LVCMOS33 [get_ports led7_b]


# ---
# PUSH BUTTONS  —  4 buttons (BTN0–BTN3), active high
# ---

set_property PACKAGE_PIN D9  [get_ports {btn[0]}]
set_property PACKAGE_PIN C9  [get_ports {btn[1]}]
set_property PACKAGE_PIN B9  [get_ports {btn[2]}]
set_property PACKAGE_PIN B8  [get_ports {btn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
set_false_path -from [get_ports {btn[*]}]


# ---
# SLIDE SWITCHES  —  4 switches (SW0–SW3), active high
# ---

set_property PACKAGE_PIN A8  [get_ports {sw[0]}]
set_property PACKAGE_PIN C11 [get_ports {sw[1]}]
set_property PACKAGE_PIN C10 [get_ports {sw[2]}]
set_property PACKAGE_PIN A10 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]


# ---
# USB-UART (Xilinx XADC chip / Digilent USB-UART)
# ---

set_property PACKAGE_PIN D10 [get_ports uart_txd]
set_property PACKAGE_PIN A9  [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# ETHERNET (Realtek RTL8211E Gigabit PHY, RGMII interface)
# ---
#
# The Arty A7 has a Gigabit Ethernet PHY connected via RGMII.
# The FPGA PACKAGE_PINs below are correct for XC7A100T.

## RGMII TX (FPGA → PHY), source-synchronous, 125 MHz DDR
set_property PACKAGE_PIN G14 [get_ports eth_txd[0]]
set_property PACKAGE_PIN H14 [get_ports eth_txd[1]]
set_property PACKAGE_PIN J13 [get_ports eth_txd[2]]
set_property PACKAGE_PIN L14 [get_ports eth_txd[3]]
set_property PACKAGE_PIN H13 [get_ports eth_tx_en]
set_property PACKAGE_PIN F14 [get_ports eth_txclk]

## RGMII RX (PHY → FPGA), source-synchronous, 125 MHz DDR
set_property PACKAGE_PIN H16 [get_ports eth_rxd[0]]
set_property PACKAGE_PIN K16 [get_ports eth_rxd[1]]
set_property PACKAGE_PIN J16 [get_ports eth_rxd[2]]
set_property PACKAGE_PIN D18 [get_ports eth_rxd[3]]
set_property PACKAGE_PIN G16 [get_ports eth_rx_dv]
set_property PACKAGE_PIN F15 [get_ports eth_rxclk]

## MDC/MDIO (Management Interface — slow, async, < 2.5 MHz)
set_property PACKAGE_PIN K13 [get_ports eth_mdc]
set_property PACKAGE_PIN L16 [get_ports eth_mdio]
set_property PACKAGE_PIN C16 [get_ports eth_rst_n]

set_property IOSTANDARD LVCMOS33 [get_ports {eth_txd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports eth_tx_en]
set_property IOSTANDARD LVCMOS33 [get_ports eth_txclk]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_dv]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rxclk]
set_property IOSTANDARD LVCMOS33 [get_ports eth_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports eth_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rst_n]

## Ethernet RX clock (from PHY) — source synchronous clock
create_clock -period 8.000 -name eth_rx_clk [get_ports eth_rxclk]

## MDIO is asynchronous management → false path
set_false_path -to   [get_ports eth_mdc]
set_false_path -from [get_ports eth_mdio]
set_false_path -to   [get_ports eth_mdio]
set_false_path -to   [get_ports eth_rst_n]


# ---
# PMOD CONNECTORS  —  JA, JB, JC, JD (high-speed differential-capable)
# ---

## JA — 8 single-ended or 4 differential pairs
set_property PACKAGE_PIN G13 [get_ports {ja[0]}]   ;# JA1
set_property PACKAGE_PIN B11 [get_ports {ja[1]}]   ;# JA2
set_property PACKAGE_PIN A11 [get_ports {ja[2]}]   ;# JA3
set_property PACKAGE_PIN D12 [get_ports {ja[3]}]   ;# JA4
set_property PACKAGE_PIN D13 [get_ports {ja[4]}]   ;# JA7
set_property PACKAGE_PIN B18 [get_ports {ja[5]}]   ;# JA8
set_property PACKAGE_PIN A18 [get_ports {ja[6]}]   ;# JA9
set_property PACKAGE_PIN K16 [get_ports {ja[7]}]   ;# JA10
set_property IOSTANDARD LVCMOS33 [get_ports {ja[*]}]

## JB — Differential pairs (can be used with LVDS)
set_property PACKAGE_PIN E15 [get_ports {jb[0]}]   ;# JB1  (diff pair: jb[0] = P)
set_property PACKAGE_PIN E16 [get_ports {jb[1]}]   ;# JB2  (diff pair: jb[1] = N)
set_property PACKAGE_PIN D15 [get_ports {jb[2]}]   ;# JB3
set_property PACKAGE_PIN C15 [get_ports {jb[3]}]   ;# JB4
set_property PACKAGE_PIN J17 [get_ports {jb[4]}]   ;# JB7
set_property PACKAGE_PIN J18 [get_ports {jb[5]}]   ;# JB8
set_property PACKAGE_PIN K15 [get_ports {jb[6]}]   ;# JB9
set_property PACKAGE_PIN J15 [get_ports {jb[7]}]   ;# JB10
set_property IOSTANDARD LVCMOS33 [get_ports {jb[*]}]


# ---
# CONFIGURATION / MISC
# ---

set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
