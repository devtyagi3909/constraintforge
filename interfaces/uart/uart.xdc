# UART constraints — Xilinx Vivado (.xdc)
#
# UART is asynchronous. There is no clock shared between your FPGA and the
# device on the other end. set_input_delay / set_output_delay are meaningless
# here — there's nothing to measure against. Use set_false_path.
#
# Your RTL still needs to handle the async input safely:
#   - 2-FF synchronizer on uart_rxd before anything else touches it
#   - Oversample RX at 16x the baud rate for data recovery
#
# The false_path doesn't prevent metastability. It just stops Vivado from
# reporting bogus timing violations on something it can't analyze.

# ---
# Pin location — replace with your actual package pins (check board schematic)
set_property PACKAGE_PIN <TX_PIN>  [get_ports uart_txd]
set_property PACKAGE_PIN <RX_PIN>  [get_ports uart_rxd]

# I/O voltage — match your bank's VCCO
# 3.3V banks: LVCMOS33, 2.5V: LVCMOS25, 1.8V: LVCMOS18
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]

# ---
# Timing exceptions — this is the important part
set_false_path -from [get_ports uart_rxd]
set_false_path -to   [get_ports uart_txd]

# Flow control (if used)
# set_false_path -from [get_ports uart_cts]
# set_false_path -to   [get_ports uart_rts]
