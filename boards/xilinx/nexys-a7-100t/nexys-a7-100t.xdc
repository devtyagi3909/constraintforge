# ---
# Nexys A7-100T Master Constraint File (XDC)
# Device: Artix-7 XC7A100T-1CSG324C
# Board:  Digilent Nexys A7-100T
# Vendor: Digilent
# Doc:    https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual
# Schematic: https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7-sch.pdf
#
# USAGE: Uncomment only the signals you use. Do NOT change PACKAGE_PIN values.
# Port names in get_ports must match your HDL top-level exactly.
# ---


# ---
# CLOCK  —  100 MHz crystal oscillator, bank 35
# ---

set_property PACKAGE_PIN E3   [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]


# ---
# RESET  —  CPU Reset button (active low), BTNC
# ---

set_property PACKAGE_PIN C12  [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_false_path -from [get_ports rst_n]


# ---
# SLIDE SWITCHES  —  SW0–SW15, active high
# ---

set_property PACKAGE_PIN J15  [get_ports {sw[0]}]
set_property PACKAGE_PIN L16  [get_ports {sw[1]}]
set_property PACKAGE_PIN M13  [get_ports {sw[2]}]
set_property PACKAGE_PIN R15  [get_ports {sw[3]}]
set_property PACKAGE_PIN R17  [get_ports {sw[4]}]
set_property PACKAGE_PIN T18  [get_ports {sw[5]}]
set_property PACKAGE_PIN U18  [get_ports {sw[6]}]
set_property PACKAGE_PIN R13  [get_ports {sw[7]}]
set_property PACKAGE_PIN T8   [get_ports {sw[8]}]
set_property PACKAGE_PIN U8   [get_ports {sw[9]}]
set_property PACKAGE_PIN R16  [get_ports {sw[10]}]
set_property PACKAGE_PIN T13  [get_ports {sw[11]}]
set_property PACKAGE_PIN H6   [get_ports {sw[12]}]
set_property PACKAGE_PIN U12  [get_ports {sw[13]}]
set_property PACKAGE_PIN U11  [get_ports {sw[14]}]
set_property PACKAGE_PIN V10  [get_ports {sw[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]


# ---
# LEDs  —  LD0–LD15, active high
# ---

set_property PACKAGE_PIN H17  [get_ports {led[0]}]
set_property PACKAGE_PIN K15  [get_ports {led[1]}]
set_property PACKAGE_PIN J13  [get_ports {led[2]}]
set_property PACKAGE_PIN N14  [get_ports {led[3]}]
set_property PACKAGE_PIN R18  [get_ports {led[4]}]
set_property PACKAGE_PIN V17  [get_ports {led[5]}]
set_property PACKAGE_PIN U17  [get_ports {led[6]}]
set_property PACKAGE_PIN U16  [get_ports {led[7]}]
set_property PACKAGE_PIN V16  [get_ports {led[8]}]
set_property PACKAGE_PIN T15  [get_ports {led[9]}]
set_property PACKAGE_PIN U14  [get_ports {led[10]}]
set_property PACKAGE_PIN T16  [get_ports {led[11]}]
set_property PACKAGE_PIN V15  [get_ports {led[12]}]
set_property PACKAGE_PIN V14  [get_ports {led[13]}]
set_property PACKAGE_PIN V12  [get_ports {led[14]}]
set_property PACKAGE_PIN V11  [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_false_path -to [get_ports {led[*]}]


# ---
# RGB LEDs  —  LD16 and LD17 (tri-color), active high
# ---

set_property PACKAGE_PIN R12  [get_ports led16_r]
set_property PACKAGE_PIN M16  [get_ports led16_g]
set_property PACKAGE_PIN N15  [get_ports led16_b]
set_property PACKAGE_PIN M15  [get_ports led17_r]
set_property PACKAGE_PIN L15  [get_ports led17_g]
set_property PACKAGE_PIN L14  [get_ports led17_b]
set_property IOSTANDARD LVCMOS33 [get_ports led16_r]
set_property IOSTANDARD LVCMOS33 [get_ports led16_g]
set_property IOSTANDARD LVCMOS33 [get_ports led16_b]
set_property IOSTANDARD LVCMOS33 [get_ports led17_r]
set_property IOSTANDARD LVCMOS33 [get_ports led17_g]
set_property IOSTANDARD LVCMOS33 [get_ports led17_b]


# ---
# 7-SEGMENT DISPLAYS  —  8-digit, common anode, active low
# ---

## Segments (active low — '0' turns segment ON)
set_property PACKAGE_PIN T10  [get_ports seg_ca]   ;# Segment A
set_property PACKAGE_PIN R10  [get_ports seg_cb]   ;# Segment B
set_property PACKAGE_PIN K16  [get_ports seg_cc]   ;# Segment C
set_property PACKAGE_PIN K13  [get_ports seg_cd]   ;# Segment D
set_property PACKAGE_PIN P15  [get_ports seg_ce]   ;# Segment E
set_property PACKAGE_PIN T11  [get_ports seg_cf]   ;# Segment F
set_property PACKAGE_PIN L18  [get_ports seg_cg]   ;# Segment G
set_property PACKAGE_PIN H15  [get_ports seg_dp]   ;# Decimal Point
set_property IOSTANDARD LVCMOS33 [get_ports seg_ca]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cb]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cc]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cd]
set_property IOSTANDARD LVCMOS33 [get_ports seg_ce]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cf]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cg]
set_property IOSTANDARD LVCMOS33 [get_ports seg_dp]

## Digit enables — 8 digits (active low — '0' selects digit)
set_property PACKAGE_PIN J17  [get_ports {an[0]}]   ;# Digit 0 (rightmost)
set_property PACKAGE_PIN J18  [get_ports {an[1]}]
set_property PACKAGE_PIN T9   [get_ports {an[2]}]
set_property PACKAGE_PIN J14  [get_ports {an[3]}]
set_property PACKAGE_PIN P14  [get_ports {an[4]}]
set_property PACKAGE_PIN T14  [get_ports {an[5]}]
set_property PACKAGE_PIN K2   [get_ports {an[6]}]
set_property PACKAGE_PIN U13  [get_ports {an[7]}]   ;# Digit 7 (leftmost)
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]


# ---
# PUSH BUTTONS  —  5 buttons, active high
# ---

set_property PACKAGE_PIN N17  [get_ports btn_c]   ;# Center
set_property PACKAGE_PIN M18  [get_ports btn_u]   ;# Up
set_property PACKAGE_PIN P17  [get_ports btn_l]   ;# Left
set_property PACKAGE_PIN M17  [get_ports btn_r]   ;# Right
set_property PACKAGE_PIN P18  [get_ports btn_d]   ;# Down
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
# USB-UART (FTDI USB-UART bridge)
# ---

set_property PACKAGE_PIN D4   [get_ports uart_txd]   ;# FPGA TX → PC
set_property PACKAGE_PIN C4   [get_ports uart_rxd]   ;# PC TX → FPGA
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# VGA OUTPUT  —  4-bit R, 4-bit G, 4-bit B + HSync + VSync
# ---

## Red (4-bit)
set_property PACKAGE_PIN A3   [get_ports {vga_r[0]}]
set_property PACKAGE_PIN B4   [get_ports {vga_r[1]}]
set_property PACKAGE_PIN C5   [get_ports {vga_r[2]}]
set_property PACKAGE_PIN A4   [get_ports {vga_r[3]}]

## Green (4-bit)
set_property PACKAGE_PIN C6   [get_ports {vga_g[0]}]
set_property PACKAGE_PIN A5   [get_ports {vga_g[1]}]
set_property PACKAGE_PIN B6   [get_ports {vga_g[2]}]
set_property PACKAGE_PIN A6   [get_ports {vga_g[3]}]

## Blue (4-bit)
set_property PACKAGE_PIN B7   [get_ports {vga_b[0]}]
set_property PACKAGE_PIN C7   [get_ports {vga_b[1]}]
set_property PACKAGE_PIN D7   [get_ports {vga_b[2]}]
set_property PACKAGE_PIN D8   [get_ports {vga_b[3]}]

## Sync
set_property PACKAGE_PIN B11  [get_ports vga_hs]
set_property PACKAGE_PIN B12  [get_ports vga_vs]

set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hs]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vs]


# ---
# ETHERNET (Realtek RTL8211E Gigabit PHY, RGMII)
# ---

## TX (FPGA → PHY)
set_property PACKAGE_PIN A10  [get_ports {eth_txd[0]}]
set_property PACKAGE_PIN A8   [get_ports {eth_txd[1]}]
set_property PACKAGE_PIN B8   [get_ports {eth_txd[2]}]
set_property PACKAGE_PIN A9   [get_ports {eth_txd[3]}]
set_property PACKAGE_PIN B9   [get_ports eth_tx_en]
set_property PACKAGE_PIN D9   [get_ports eth_gtxclk]

## RX (PHY → FPGA)
set_property PACKAGE_PIN D10  [get_ports {eth_rxd[0]}]
set_property PACKAGE_PIN C11  [get_ports {eth_rxd[1]}]
set_property PACKAGE_PIN C10  [get_ports {eth_rxd[2]}]
set_property PACKAGE_PIN A10  [get_ports {eth_rxd[3]}]
set_property PACKAGE_PIN C9   [get_ports eth_rx_dv]
set_property PACKAGE_PIN D11  [get_ports eth_rxclk]

## Management
set_property PACKAGE_PIN C8   [get_ports eth_mdc]
set_property PACKAGE_PIN D8   [get_ports eth_mdio]
set_property PACKAGE_PIN C12  [get_ports eth_rst_n]

set_property IOSTANDARD LVCMOS33 [get_ports {eth_txd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports eth_tx_en]
set_property IOSTANDARD LVCMOS33 [get_ports eth_gtxclk]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_dv]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rxclk]
set_property IOSTANDARD LVCMOS33 [get_ports eth_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports eth_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rst_n]

create_clock -period 8.000 -name eth_rxclk [get_ports eth_rxclk]
set_false_path -to   [get_ports eth_mdc]
set_false_path -from [get_ports eth_mdio]
set_false_path -to   [get_ports eth_mdio]
set_false_path -to   [get_ports eth_rst_n]


# ---
# PMOD CONNECTORS  —  JA, JB, JC, JD (standard), JXADC (analog/diff-capable)
# ---

## JA
set_property PACKAGE_PIN C17  [get_ports {ja[0]}]
set_property PACKAGE_PIN D18  [get_ports {ja[1]}]
set_property PACKAGE_PIN E18  [get_ports {ja[2]}]
set_property PACKAGE_PIN G17  [get_ports {ja[3]}]
set_property PACKAGE_PIN D17  [get_ports {ja[4]}]
set_property PACKAGE_PIN E17  [get_ports {ja[5]}]
set_property PACKAGE_PIN F18  [get_ports {ja[6]}]
set_property PACKAGE_PIN G18  [get_ports {ja[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[*]}]

## JB (differential-capable pairs)
set_property PACKAGE_PIN D14  [get_ports {jb[0]}]   ;# JB1  P-side of pair 0
set_property PACKAGE_PIN F16  [get_ports {jb[1]}]   ;# JB2  N-side of pair 0
set_property PACKAGE_PIN G16  [get_ports {jb[2]}]   ;# JB3
set_property PACKAGE_PIN H14  [get_ports {jb[3]}]   ;# JB4
set_property PACKAGE_PIN E16  [get_ports {jb[4]}]   ;# JB7
set_property PACKAGE_PIN F13  [get_ports {jb[5]}]   ;# JB8
set_property PACKAGE_PIN G13  [get_ports {jb[6]}]   ;# JB9
set_property PACKAGE_PIN H16  [get_ports {jb[7]}]   ;# JB10
set_property IOSTANDARD LVCMOS33 [get_ports {jb[*]}]

## JC (standard)
set_property PACKAGE_PIN K1   [get_ports {jc[0]}]
set_property PACKAGE_PIN F6   [get_ports {jc[1]}]
set_property PACKAGE_PIN J2   [get_ports {jc[2]}]
set_property PACKAGE_PIN G6   [get_ports {jc[3]}]
set_property PACKAGE_PIN E7   [get_ports {jc[4]}]
set_property PACKAGE_PIN J3   [get_ports {jc[5]}]
set_property PACKAGE_PIN J4   [get_ports {jc[6]}]
set_property PACKAGE_PIN E6   [get_ports {jc[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {jc[*]}]

## JD (standard)
set_property PACKAGE_PIN H4   [get_ports {jd[0]}]
set_property PACKAGE_PIN H1   [get_ports {jd[1]}]
set_property PACKAGE_PIN G1   [get_ports {jd[2]}]
set_property PACKAGE_PIN G3   [get_ports {jd[3]}]
set_property PACKAGE_PIN H2   [get_ports {jd[4]}]
set_property PACKAGE_PIN G4   [get_ports {jd[5]}]
set_property PACKAGE_PIN G2   [get_ports {jd[6]}]
set_property PACKAGE_PIN F3   [get_ports {jd[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {jd[*]}]


# ---
# MICROPHONE (PDM microphone — Knowles SPH1642HT5H)
# ---

set_property PACKAGE_PIN J5   [get_ports mic_clk]    ;# PDM clock output to mic
set_property PACKAGE_PIN H5   [get_ports mic_data]   ;# PDM data input from mic
set_property IOSTANDARD LVCMOS33 [get_ports mic_clk]
set_property IOSTANDARD LVCMOS33 [get_ports mic_data]


# ---
# AUDIO AMPLIFIER (SSM2603 Audio Codec via I2C + I2S on Nexys A7)
# ---
#
# Note: The Nexys A7 does NOT have the same audio setup as the Nexys 4 DDR.
# The Nexys A7 has only a PDM microphone and a mono PWM audio output.

set_property PACKAGE_PIN A11  [get_ports aud_pwm]    ;# PWM audio output
set_property PACKAGE_PIN D12  [get_ports aud_sd]     ;# Audio amplifier shutdown (active high = enable)
set_property IOSTANDARD LVCMOS33 [get_ports aud_pwm]
set_property IOSTANDARD LVCMOS33 [get_ports aud_sd]


# ---
# CONFIGURATION
# ---

set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
