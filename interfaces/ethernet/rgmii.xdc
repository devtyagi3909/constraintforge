# ---
# RGMII ETHERNET CONSTRAINTS  —  Xilinx Vivado (.xdc)
# ---
#
# RGMII (Reduced Gigabit Media Independent Interface) is the standard
# interface between an FPGA and a GbE PHY chip. It is source-synchronous DDR:
#   - Data changes on BOTH rising and falling edges of a 125 MHz clock
#   - TX: FPGA drives TXD[3:0], TXCTL, and GTXCLK → to PHY
#   - RX: PHY drives RXD[3:0], RXCTL, and provides RXCLK → to FPGA
#
# RGMII TIMING (from IEEE 802.3-2012, Section 35, and RGMII v2.0 spec):
#   TX (FPGA → PHY):
#     tSU_TX = 1.0 ns  (setup time before GTXCLK rising edge)
#     tH_TX  = 1.0 ns  (hold time after GTXCLK rising edge)
#   RX (PHY → FPGA):
#     tCO_max = 1.5 ns  (PHY output valid, worst case after RXCLK edge)
#     tCO_min = 1.0 ns  (PHY output valid, best case)
#
# #   Xilinx recommends using IODELAY2/IDELAYE2 primitives on the RX path to
#   center the sampling point inside the RX data valid window. Without delay
#   tuning, setup/hold margin may be marginal at 125 MHz.
#
# For production designs, use the Tri-Mode Ethernet MAC (TEMAC) IP or
# the open-source LiteEth or verilog-ethernet — they handle IDDR/ODDR and
# include correct constraint templates.
#
# Reference: RGMII Interface Specification v2.0 (HP Labs / AMCC)
# ---


# Clock Constraints

# RX clock from PHY — PHY drives this, FPGA receives it.
# At 1 Gbps (RGMII), RXCLK = 125 MHz = 8.0 ns period.
create_clock -period 8.000 -name eth_rxclk [get_ports eth_rxclk]

# TX clock — FPGA generates GTXCLK from its MMCM.
# Define as a generated clock from the MMCM that produces 125 MHz.
# (Adjust -source path to match your MMCM instance name)
create_generated_clock \
    -name eth_gtxclk \
    -source [get_pins u_mmcm/CLKIN1] \
    -divide_by 1 \
    [get_ports eth_gtxclk]
#   ^^^ Assumes MMCM directly generates 125 MHz for GTXCLK.
#   If your sys_clk is 125 MHz and you use it directly:
#   create_generated_clock -name eth_gtxclk -source [get_ports clk] [get_ports eth_gtxclk]


# Pin Location
# (Arty A7-100T shown — see boards/ for your specific board)

## TX path (FPGA → PHY)
set_property PACKAGE_PIN G14  [get_ports {eth_txd[0]}]
set_property PACKAGE_PIN H14  [get_ports {eth_txd[1]}]
set_property PACKAGE_PIN J13  [get_ports {eth_txd[2]}]
set_property PACKAGE_PIN L14  [get_ports {eth_txd[3]}]
set_property PACKAGE_PIN H13  [get_ports eth_txctl]
set_property PACKAGE_PIN F14  [get_ports eth_gtxclk]

## RX path (PHY → FPGA)
set_property PACKAGE_PIN H16  [get_ports {eth_rxd[0]}]
set_property PACKAGE_PIN K16  [get_ports {eth_rxd[1]}]
set_property PACKAGE_PIN J16  [get_ports {eth_rxd[2]}]
set_property PACKAGE_PIN D18  [get_ports {eth_rxd[3]}]
set_property PACKAGE_PIN G16  [get_ports eth_rxctl]
set_property PACKAGE_PIN F15  [get_ports eth_rxclk]

## Management (MDIO — async, slow)
set_property PACKAGE_PIN K13  [get_ports eth_mdc]
set_property PACKAGE_PIN L16  [get_ports eth_mdio]
set_property PACKAGE_PIN C16  [get_ports eth_rst_n]

## I/O Standards (RGMII is 3.3V LVTTL on most dev boards)
set_property IOSTANDARD LVCMOS33 [get_ports {eth_txd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports eth_txctl]
set_property IOSTANDARD LVCMOS33 [get_ports eth_gtxclk]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rxctl]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rxclk]
set_property IOSTANDARD LVCMOS33 [get_ports eth_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports eth_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rst_n]

## TX drive strength — use 12mA fast slew for 125 MHz RGMII signals
set_property DRIVE 12     [get_ports {eth_txd[*]}]
set_property SLEW  FAST   [get_ports {eth_txd[*]}]
set_property DRIVE 12     [get_ports eth_txctl]
set_property SLEW  FAST   [get_ports eth_txctl]
set_property DRIVE 12     [get_ports eth_gtxclk]
set_property SLEW  FAST   [get_ports eth_gtxclk]


# TX Output Delays (FPGA → PHY)
#
# RGMII TX spec requires data valid ±1 ns around the GTXCLK edge.
# set_output_delay -max = tSU_PHY (PHY's setup requirement)
# set_output_delay -min = -tH_PHY (negative hold requirement)
#
# DDR output: data changes on BOTH rising and falling edges.
# Must constrain both edges explicitly.

# Rising edge captures:
set_output_delay -clock eth_gtxclk -max  1.0 [get_ports {eth_txd[*]}]
set_output_delay -clock eth_gtxclk -min -1.0 [get_ports {eth_txd[*]}]
set_output_delay -clock eth_gtxclk -max  1.0 [get_ports eth_txctl]
set_output_delay -clock eth_gtxclk -min -1.0 [get_ports eth_txctl]

# Falling edge captures (add -clock_fall):
set_output_delay -clock eth_gtxclk -clock_fall -max  1.0 [get_ports {eth_txd[*]}]
set_output_delay -clock eth_gtxclk -clock_fall -min -1.0 [get_ports {eth_txd[*]}]
set_output_delay -clock eth_gtxclk -clock_fall -max  1.0 [get_ports eth_txctl]
set_output_delay -clock eth_gtxclk -clock_fall -min -1.0 [get_ports eth_txctl]


# RX Input Delays (PHY → FPGA)
#
# PHY drives RXD/RXCTL and RXCLK simultaneously. Data is center-aligned:
#   - PHY output valid window: ±1 ns around RXCLK edge (RGMII v2.0 spec)
#   - set_input_delay -max = tCO_max (1.5 ns typical)
#   - set_input_delay -min = tCO_min (1.0 ns typical, or can be negative for early data)
#
# DDR input: capture on both rising and falling edge of RXCLK.

# Rising edge:
set_input_delay -clock eth_rxclk -max 1.5 [get_ports {eth_rxd[*]}]
set_input_delay -clock eth_rxclk -min 1.0 [get_ports {eth_rxd[*]}]
set_input_delay -clock eth_rxclk -max 1.5 [get_ports eth_rxctl]
set_input_delay -clock eth_rxclk -min 1.0 [get_ports eth_rxctl]

# Falling edge:
set_input_delay -clock eth_rxclk -clock_fall -max 1.5 [get_ports {eth_rxd[*]}]
set_input_delay -clock eth_rxclk -clock_fall -min 1.0 [get_ports {eth_rxd[*]}]
set_input_delay -clock eth_rxclk -clock_fall -max 1.5 [get_ports eth_rxctl]
set_input_delay -clock eth_rxclk -clock_fall -min 1.0 [get_ports eth_rxctl]


# MDIO / Reset — Async false paths
#
# MDIO is a management interface running at < 2.5 MHz. It's asynchronous.
# PHY reset is a slow async control signal. Both are false paths.
set_false_path -to   [get_ports eth_mdc]
set_false_path -from [get_ports eth_mdio]
set_false_path -to   [get_ports eth_mdio]
set_false_path -to   [get_ports eth_rst_n]


# CDC — RXCLK domain to application clock
#
# RXCLK comes from the PHY and is independent of your sys_clk.
# Any path from the ETH RX domain to your application must cross through
# an async FIFO. Tell Vivado they are unrelated:
set_clock_groups -asynchronous \
    -group [get_clocks eth_rxclk] \
    -group [get_clocks sys_clk]

# Also isolate TX clock if it's from a separate MMCM output:
# set_clock_groups -asynchronous \
#     -group [get_clocks eth_gtxclk] \
#     -group [get_clocks sys_clk]
