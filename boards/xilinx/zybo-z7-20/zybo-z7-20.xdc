# ---
# Zybo Z7-20 Master Constraint File (XDC)
# Device: Zynq-7000 XC7Z020-1CLG400C
# Board:  Digilent Zybo Z7-20
# Vendor: Digilent
# Doc:    https://digilent.com/reference/programmable-logic/zybo-z7/reference-manual
# Schematic: https://digilent.com/reference/_media/reference/programmable-logic/zybo-z7/zybo_z7_sch-public.pdf
#
# The Zybo Z7 is a Zynq SoC board. The PS (ARM) and PL (FPGA logic) are
# on the same die. PL I/O banks default to 3.3V (bank 34/35) or 1.8V (bank 13).
# Always verify VCCO for your bank before setting IOSTANDARD.
# ---


# ---
# CLOCK  —  125 MHz PS clock → PL via PS7 FCLK_CLK0
# ---
#
# The Zybo Z7 does NOT have a standalone crystal oscillator directly on the PL.
# The main clock for PL logic comes from the PS FCLK_CLK0 output, configured
# in the PS7 IP block to your desired frequency (typically 100 or 125 MHz).
#
# In Vivado (Block Design):
#   Add Zynq PS7 IP → Double-click → Clock Configuration → PL Fabric Clocks
#   Set FCLK_CLK0 to your target frequency (100 MHz typical)
#
# The FCLK clock constraint is generated automatically by Vivado when using
# the PS7 IP. If writing manually:
# create_clock -period 10.000 -name fclk0 [get_nets -hierarchical FCLK_CLK0]
#
# If you use the standalone 125 MHz oscillator on the board (K17):
set_property PACKAGE_PIN K17  [get_ports clk_125]
set_property IOSTANDARD LVCMOS33 [get_ports clk_125]
create_clock -period 8.000 -name clk_125mhz [get_ports clk_125]


# ---
# LEDs  —  LD0–LD3, active high
# ---

set_property PACKAGE_PIN M14  [get_ports {led[0]}]
set_property PACKAGE_PIN M15  [get_ports {led[1]}]
set_property PACKAGE_PIN G14  [get_ports {led[2]}]
set_property PACKAGE_PIN D18  [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_false_path -to [get_ports {led[*]}]


# ---
# PUSH BUTTONS  —  BTN0–BTN3, active high
# ---

set_property PACKAGE_PIN K18  [get_ports {btn[0]}]
set_property PACKAGE_PIN P16  [get_ports {btn[1]}]
set_property PACKAGE_PIN K19  [get_ports {btn[2]}]
set_property PACKAGE_PIN Y16  [get_ports {btn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
set_false_path -from [get_ports {btn[*]}]


# ---
# SLIDE SWITCHES  —  SW0–SW3, active high
# ---

set_property PACKAGE_PIN G15  [get_ports {sw[0]}]
set_property PACKAGE_PIN P15  [get_ports {sw[1]}]
set_property PACKAGE_PIN W13  [get_ports {sw[2]}]
set_property PACKAGE_PIN T16  [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]


# ---
# HDMI OUTPUT (TMDS — Type A connector)
# ---

set_property PACKAGE_PIN H17  [get_ports hdmi_tx_clk_p]
set_property PACKAGE_PIN H18  [get_ports hdmi_tx_clk_n]
set_property PACKAGE_PIN V20  [get_ports {hdmi_tx_p[0]}]   ;# D0 Blue
set_property PACKAGE_PIN W20  [get_ports {hdmi_tx_n[0]}]
set_property PACKAGE_PIN T20  [get_ports {hdmi_tx_p[1]}]   ;# D1 Green
set_property PACKAGE_PIN U20  [get_ports {hdmi_tx_n[1]}]
set_property PACKAGE_PIN P20  [get_ports {hdmi_tx_p[2]}]   ;# D2 Red
set_property PACKAGE_PIN R20  [get_ports {hdmi_tx_n[2]}]
set_property PACKAGE_PIN T19  [get_ports hdmi_tx_hpd]      ;# Hot plug detect (input from monitor)

set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[*]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_hpd]
set_false_path -to   [get_ports {hdmi_tx_p[*]}]
set_false_path -to   [get_ports {hdmi_tx_n[*]}]
set_false_path -to   [get_ports hdmi_tx_clk_p]
set_false_path -to   [get_ports hdmi_tx_clk_n]
set_false_path -from [get_ports hdmi_tx_hpd]


# ---
# HDMI INPUT (TMDS — Type A connector)
# ---

set_property PACKAGE_PIN N18  [get_ports hdmi_rx_clk_p]
set_property PACKAGE_PIN P19  [get_ports hdmi_rx_clk_n]
set_property PACKAGE_PIN V18  [get_ports {hdmi_rx_p[0]}]
set_property PACKAGE_PIN W18  [get_ports {hdmi_rx_n[0]}]
set_property PACKAGE_PIN R19  [get_ports {hdmi_rx_p[1]}]
set_property PACKAGE_PIN T19  [get_ports {hdmi_rx_n[1]}]
set_property PACKAGE_PIN P17  [get_ports {hdmi_rx_p[2]}]
set_property PACKAGE_PIN R17  [get_ports {hdmi_rx_n[2]}]
set_property PACKAGE_PIN V19  [get_ports hdmi_rx_hpd]      ;# FPGA drives HPD to source

set_property IOSTANDARD TMDS_33 [get_ports hdmi_rx_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_rx_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_rx_p[*]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_rx_n[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_rx_hpd]

# HDMI RX clock — define when using HDMI input receiver
# create_clock -period 13.468 -name hdmi_rx_clk [get_ports hdmi_rx_clk_p]
# ^^ 13.468 ns = 74.25 MHz for 720p — adjust per input resolution


# ---
# AUDIO (Cirrus Logic CS4344 DAC + ADAU1761 Codec via SSM2603)
# ---
#
# The Zybo Z7 uses an SSM2603 audio codec connected via I2C (config) and I2S (data).

## I2C (configuration interface — slow, async)
set_property PACKAGE_PIN N18  [get_ports ac_scl]
set_property PACKAGE_PIN N17  [get_ports ac_sda]
set_property IOSTANDARD LVCMOS33 [get_ports ac_scl]
set_property IOSTANDARD LVCMOS33 [get_ports ac_sda]
set_false_path -from [get_ports ac_scl]
set_false_path -from [get_ports ac_sda]
set_false_path -to   [get_ports ac_scl]
set_false_path -to   [get_ports ac_sda]

## I2S (audio data interface)
set_property PACKAGE_PIN R18  [get_ports ac_mclk]   ;# Master clock to codec
set_property PACKAGE_PIN T19  [get_ports ac_bclk]   ;# I2S bit clock
set_property PACKAGE_PIN R16  [get_ports ac_lrclk]  ;# L/R clock (word select)
set_property PACKAGE_PIN P18  [get_ports ac_adc_sdata]  ;# ADC serial data → FPGA
set_property PACKAGE_PIN R17  [get_ports ac_dac_sdata]  ;# DAC serial data ← FPGA
set_property IOSTANDARD LVCMOS33 [get_ports ac_mclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_bclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports ac_adc_sdata]
set_property IOSTANDARD LVCMOS33 [get_ports ac_dac_sdata]


# ---
# USB-UART (via Cypress CY7C64225 USB-UART bridge)
# ---

set_property PACKAGE_PIN V12  [get_ports uart_txd]
set_property PACKAGE_PIN V13  [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]


# ---
# PMOD CONNECTORS  —  JA, JB, JC, JD, JE (all 12-pin)
# ---

## JA (differential-capable — High-Speed Pmod)
set_property PACKAGE_PIN Y18  [get_ports {ja[0]}]   ;# JA1  P
set_property PACKAGE_PIN Y19  [get_ports {ja[1]}]   ;# JA2  N
set_property PACKAGE_PIN Y16  [get_ports {ja[2]}]   ;# JA3  P
set_property PACKAGE_PIN Y17  [get_ports {ja[3]}]   ;# JA4  N
set_property PACKAGE_PIN U18  [get_ports {ja[4]}]   ;# JA7  P
set_property PACKAGE_PIN U19  [get_ports {ja[5]}]   ;# JA8  N
set_property PACKAGE_PIN W18  [get_ports {ja[6]}]   ;# JA9  P
set_property PACKAGE_PIN W19  [get_ports {ja[7]}]   ;# JA10 N
set_property IOSTANDARD LVCMOS33 [get_ports {ja[*]}]

## JB
set_property PACKAGE_PIN W14  [get_ports {jb[0]}]
set_property PACKAGE_PIN Y14  [get_ports {jb[1]}]
set_property PACKAGE_PIN T11  [get_ports {jb[2]}]
set_property PACKAGE_PIN T10  [get_ports {jb[3]}]
set_property PACKAGE_PIN V16  [get_ports {jb[4]}]
set_property PACKAGE_PIN W16  [get_ports {jb[5]}]
set_property PACKAGE_PIN V12  [get_ports {jb[6]}]
set_property PACKAGE_PIN W13  [get_ports {jb[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {jb[*]}]

## JC
set_property PACKAGE_PIN V15  [get_ports {jc[0]}]
set_property PACKAGE_PIN W15  [get_ports {jc[1]}]
set_property PACKAGE_PIN T12  [get_ports {jc[2]}]
set_property PACKAGE_PIN U12  [get_ports {jc[3]}]
set_property PACKAGE_PIN V13  [get_ports {jc[4]}]
set_property PACKAGE_PIN V14  [get_ports {jc[5]}]
set_property PACKAGE_PIN T14  [get_ports {jc[6]}]
set_property PACKAGE_PIN T15  [get_ports {jc[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {jc[*]}]

## JD
set_property PACKAGE_PIN T17  [get_ports {jd[0]}]
set_property PACKAGE_PIN U17  [get_ports {jd[1]}]
set_property PACKAGE_PIN P15  [get_ports {jd[2]}]
set_property PACKAGE_PIN R16  [get_ports {jd[3]}]
set_property PACKAGE_PIN R14  [get_ports {jd[4]}]
set_property PACKAGE_PIN T14  [get_ports {jd[5]}]
set_property PACKAGE_PIN P14  [get_ports {jd[6]}]
set_property PACKAGE_PIN R13  [get_ports {jd[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {jd[*]}]

## JE (bank 13 — 1.8V! Do not connect 3.3V signals here)
set_property PACKAGE_PIN V10  [get_ports {je[0]}]
set_property PACKAGE_PIN W10  [get_ports {je[1]}]
set_property PACKAGE_PIN W6   [get_ports {je[2]}]
set_property PACKAGE_PIN Y6   [get_ports {je[3]}]
set_property PACKAGE_PIN Y9   [get_ports {je[4]}]
set_property PACKAGE_PIN Y8   [get_ports {je[5]}]
set_property PACKAGE_PIN W9   [get_ports {je[6]}]
set_property PACKAGE_PIN Y7   [get_ports {je[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {je[*]}]
;# ^^^ BANK 13 = 1.8V — MUST be LVCMOS18 not LVCMOS33


# ---
# CONFIGURATION
# ---

set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
