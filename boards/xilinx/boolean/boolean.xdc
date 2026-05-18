# ---
# Boolean Board Master Constraint File (XDC)
# Device: Artix-7 XC7A35T-1CPG236C
# Board:  Real Digital Boolean Board
# Vendor: Real Digital
# Doc:    https://www.realdigital.org/doc/boolean
# Schematic: https://www.realdigital.org/downloads/boolean_schematic.pdf
#
# The Boolean Board is purpose-built for digital logic education. It is rapidly
# replacing older breadboard-based setups in university intro courses (2022–2026).
# It includes on-board debounced buttons, 7-segment displays, VGA, and UART.
# ---


# ---
# CLOCK  —  100 MHz crystal oscillator
# ---

set_property PACKAGE_PIN W5   [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]


# ---
# SLIDE SWITCHES  —  SW0–SW15, active high
# ---

set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2  [get_ports {sw[8]}]
set_property PACKAGE_PIN T3  [get_ports {sw[9]}]
set_property PACKAGE_PIN T2  [get_ports {sw[10]}]
set_property PACKAGE_PIN R3  [get_ports {sw[11]}]
set_property PACKAGE_PIN W2  [get_ports {sw[12]}]
set_property PACKAGE_PIN U1  [get_ports {sw[13]}]
set_property PACKAGE_PIN T1  [get_ports {sw[14]}]
set_property PACKAGE_PIN R2  [get_ports {sw[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]


# ---
# LEDs  —  LD0–LD15, active high
# ---

set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]
set_property PACKAGE_PIN V3  [get_ports {led[9]}]
set_property PACKAGE_PIN W3  [get_ports {led[10]}]
set_property PACKAGE_PIN U3  [get_ports {led[11]}]
set_property PACKAGE_PIN P3  [get_ports {led[12]}]
set_property PACKAGE_PIN N3  [get_ports {led[13]}]
set_property PACKAGE_PIN P1  [get_ports {led[14]}]
set_property PACKAGE_PIN L1  [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_false_path -to [get_ports {led[*]}]


# ---
# 7-SEGMENT DISPLAY  —  4-digit, common anode, active low
# ---

set_property PACKAGE_PIN W7  [get_ports seg_ca]
set_property PACKAGE_PIN W6  [get_ports seg_cb]
set_property PACKAGE_PIN U8  [get_ports seg_cc]
set_property PACKAGE_PIN V8  [get_ports seg_cd]
set_property PACKAGE_PIN U5  [get_ports seg_ce]
set_property PACKAGE_PIN V5  [get_ports seg_cf]
set_property PACKAGE_PIN U7  [get_ports seg_cg]
set_property PACKAGE_PIN V7  [get_ports seg_dp]
set_property IOSTANDARD LVCMOS33 [get_ports seg_ca]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cb]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cc]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cd]
set_property IOSTANDARD LVCMOS33 [get_ports seg_ce]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cf]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cg]
set_property IOSTANDARD LVCMOS33 [get_ports seg_dp]

set_property PACKAGE_PIN U2  [get_ports {an[0]}]
set_property PACKAGE_PIN U4  [get_ports {an[1]}]
set_property PACKAGE_PIN V4  [get_ports {an[2]}]
set_property PACKAGE_PIN W4  [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]


# ---
# PUSH BUTTONS  —  BTNC/BTNU/BTNL/BTNR/BTND, active high
# ---

set_property PACKAGE_PIN U18 [get_ports btn_c]
set_property PACKAGE_PIN T18 [get_ports btn_u]
set_property PACKAGE_PIN W19 [get_ports btn_l]
set_property PACKAGE_PIN T17 [get_ports btn_r]
set_property PACKAGE_PIN U17 [get_ports btn_d]
set_property IOSTANDARD LVCMOS33 [get_ports btn_c]
set_property IOSTANDARD LVCMOS33 [get_ports btn_u]
set_property IOSTANDARD LVCMOS33 [get_ports btn_l]
set_property IOSTANDARD LVCMOS33 [get_ports btn_r]
set_property IOSTANDARD LVCMOS33 [get_ports btn_d]
set_false_path -from [get_ports btn_c]
set_false_path -from [get_ports btn_u]
set_false_path -from [get_ports btn_l]
set_false_path -from [get_ports btn_r]
set_false_path -from [get_ports btn_d]


# ---
# USB-UART
# ---

set_property PACKAGE_PIN B18 [get_ports uart_txd]
set_property PACKAGE_PIN A18 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# VGA  —  4-bit R, 4-bit G, 4-bit B
# ---

set_property PACKAGE_PIN G19 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN H19 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN J19 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN N19 [get_ports {vga_r[3]}]
set_property PACKAGE_PIN J17 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN H17 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN G17 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN D17 [get_ports {vga_g[3]}]
set_property PACKAGE_PIN N18 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN L18 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN K18 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN J18 [get_ports {vga_b[3]}]
set_property PACKAGE_PIN P19 [get_ports vga_hs]
set_property PACKAGE_PIN R19 [get_ports vga_vs]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hs]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vs]


# ---
# CONFIGURATION
# ---

set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
