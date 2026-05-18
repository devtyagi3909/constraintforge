# ---
# PYNQ-Z2 Master Constraint File (XDC)
# Device: Zynq-7000 XC7Z020-1CLG400C
# Board:  TUL PYNQ-Z2
# Vendor: TUL (Turing Intelligence Technology)
# Doc:    https://www.tul.com.tw/ProductsPYNQ-Z2.html
# ---


# ---
# CLOCK
# ---

## 125 MHz PS clock (from PS FCLKCLK[0] to PL via PS7 block)
## In your design, this is driven by the PS IP's FCLK_CLK0 output.
## Constrain the net from the PS7 cell:
# create_generated_clock -name pl_clk0 -source [get_pins ps7_inst/FCLKCLK[0]] ...

## 125 MHz on-board oscillator to PL (bank 35)
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 8.000 -name sys_clk -waveform {0.000 4.000} [get_ports clk]


# ---
# PUSH BUTTONS  —  2 buttons, active low
# ---

set_property PACKAGE_PIN D19 [get_ports {btn[0]}]
set_property PACKAGE_PIN D20 [get_ports {btn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
set_false_path -from [get_ports {btn[*]}]


# ---
# SLIDE SWITCHES  —  2 slide switches, active high
# ---

set_property PACKAGE_PIN M20 [get_ports {sw[0]}]
set_property PACKAGE_PIN M19 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]


# ---
# LEDs  —  4 LEDs, active high
# ---

set_property PACKAGE_PIN R14 [get_ports {led[0]}]
set_property PACKAGE_PIN P14 [get_ports {led[1]}]
set_property PACKAGE_PIN N16 [get_ports {led[2]}]
set_property PACKAGE_PIN M14 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]


# ---
# HDMI OUTPUT (TMDS)
# ---

set_property PACKAGE_PIN L17  [get_ports hdmi_tx_clk_p]
set_property PACKAGE_PIN L18  [get_ports hdmi_tx_clk_n]
set_property PACKAGE_PIN R17  [get_ports {hdmi_tx_p[0]}]
set_property PACKAGE_PIN T17  [get_ports {hdmi_tx_n[0]}]
set_property PACKAGE_PIN R16  [get_ports {hdmi_tx_p[1]}]
set_property PACKAGE_PIN R15  [get_ports {hdmi_tx_n[1]}]
set_property PACKAGE_PIN P16  [get_ports {hdmi_tx_p[2]}]
set_property PACKAGE_PIN P15  [get_ports {hdmi_tx_n[2]}]

set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[*]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[*]}]


# ---
# HDMI INPUT (TMDS)
# ---

set_property PACKAGE_PIN N18  [get_ports hdmi_rx_clk_p]
set_property PACKAGE_PIN P19  [get_ports hdmi_rx_clk_n]
set_property PACKAGE_PIN U19  [get_ports {hdmi_rx_p[0]}]
set_property PACKAGE_PIN V19  [get_ports {hdmi_rx_n[0]}]
set_property PACKAGE_PIN T18  [get_ports {hdmi_rx_p[1]}]
set_property PACKAGE_PIN U18  [get_ports {hdmi_rx_n[1]}]
set_property PACKAGE_PIN R19  [get_ports {hdmi_rx_p[2]}]
set_property PACKAGE_PIN T19  [get_ports {hdmi_rx_n[2]}]

set_property IOSTANDARD TMDS_33 [get_ports hdmi_rx_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_rx_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_rx_p[*]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_rx_n[*]}]

## HDMI RX clock — define as primary clock when using HDMI RX
# create_clock -period 13.468 -name hdmi_rx_clk [get_ports hdmi_rx_clk_p]
# (13.468 ns = 74.25 MHz for 720p — adjust for your input resolution)


# ---
# AUDIO  —  Analog Devices ADAU1761 I2S Codec
# ---

set_property PACKAGE_PIN R18  [get_ports i2s_bclk]     ;# I2S bit clock
set_property PACKAGE_PIN T19  [get_ports i2s_lrclk]    ;# I2S LR clock
set_property PACKAGE_PIN R18  [get_ports i2s_sdata_o]  ;# I2S data out (to DAC)
set_property PACKAGE_PIN R19  [get_ports i2s_sdata_i]  ;# I2S data in  (from ADC)
set_property PACKAGE_PIN N17  [get_ports i2c_scl]      ;# Codec I2C SCL
set_property PACKAGE_PIN P18  [get_ports i2c_sda]      ;# Codec I2C SDA

set_property IOSTANDARD LVCMOS33 [get_ports i2s_bclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_sdata_o]
set_property IOSTANDARD LVCMOS33 [get_ports i2s_sdata_i]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_scl]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_sda]

set_false_path -from [get_ports i2c_scl]
set_false_path -from [get_ports i2c_sda]
set_false_path -to   [get_ports i2c_scl]
set_false_path -to   [get_ports i2c_sda]


# ---
# PMOD CONNECTORS  —  JA (8 I/O) and JB (8 I/O)
# ---

set_property PACKAGE_PIN Y18  [get_ports {ja[0]}]
set_property PACKAGE_PIN Y19  [get_ports {ja[1]}]
set_property PACKAGE_PIN Y16  [get_ports {ja[2]}]
set_property PACKAGE_PIN Y17  [get_ports {ja[3]}]
set_property PACKAGE_PIN U18  [get_ports {ja[4]}]
set_property PACKAGE_PIN U19  [get_ports {ja[5]}]
set_property PACKAGE_PIN W18  [get_ports {ja[6]}]
set_property PACKAGE_PIN W19  [get_ports {ja[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ja[*]}]

set_property PACKAGE_PIN W14  [get_ports {jb[0]}]
set_property PACKAGE_PIN Y14  [get_ports {jb[1]}]
set_property PACKAGE_PIN T11  [get_ports {jb[2]}]
set_property PACKAGE_PIN T10  [get_ports {jb[3]}]
set_property PACKAGE_PIN V16  [get_ports {jb[4]}]
set_property PACKAGE_PIN W16  [get_ports {jb[5]}]
set_property PACKAGE_PIN V12  [get_ports {jb[6]}]
set_property PACKAGE_PIN W13  [get_ports {jb[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {jb[*]}]


# ---
# CONFIGURATION
# ---

set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
