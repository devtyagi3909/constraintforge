# ---
# I2C CONSTRAINTS  —  Xilinx Vivado (.xdc)
# ---
#
# I2C (Inter-Integrated Circuit) is an asynchronous, open-drain,
# bidirectional interface running at very low speeds:
#   Standard Mode:  100 kHz
#   Fast Mode:      400 kHz
#   Fast-Plus Mode: 1 MHz
#   High-Speed:     3.4 MHz (rare on FPGAs)
#
# Because I2C signals are:
#   1. Open-drain (require external pull-up resistors, typically 4.7 kΩ)
#   2. Very slow (100-400 kHz vs FPGA clocks at 50-200 MHz)
#   3. Asynchronous (no shared clock between master and slave)
#
# The correct constraints are:
#   - set_false_path on SCL and SDA
#   - Configure I/O for open-drain behavior
#
# OPEN DRAIN IN FPGA:
#   True open-drain is not directly supported in all FPGA I/O banks.
#   The standard approach is:
#     - Drive 0 to assert (pull line low)
#     - Tristate (high-Z) to deassert (let external pull-up bring it high)
#   In your HDL: use a tri-state enable signal, not a direct '1' output
#
# Reference: I2C Bus Specification and User Manual (NXP UM10204)
# ---


# Pin Location Constraints
set_property PACKAGE_PIN <SCL_PIN> [get_ports i2c_scl]
set_property PACKAGE_PIN <SDA_PIN> [get_ports i2c_sda]

# I/O Standard:
# Most I2C is at 3.3V. If on a 1.8V bank, use LVCMOS18.
# Do not exceed the VCCO voltage of the bank your pins are in.
set_property IOSTANDARD LVCMOS33 [get_ports i2c_scl]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_sda]


# Open-Drain Configuration
#
# Xilinx 7-Series and UltraScale have a dedicated open-drain mode.
# Setting this to TRUE makes the output buffer behave as open-drain:
#   - When driving '0' → output pulls low
#   - When driving '1' → output goes high-impedance (external pull-up does the work)
#
# This is the correct FPGA implementation of I2C's open-drain requirement.
# Without this, you'd need to explicitly tristate in your RTL when outputting '1'.
#
set_property DRIVE 4          [get_ports i2c_scl]  ;# 4 mA is sufficient for I2C
set_property DRIVE 4          [get_ports i2c_sda]
set_property SLEW  SLOW       [get_ports i2c_scl]  ;# SLOW slew avoids ringing on pull-up
set_property SLEW  SLOW       [get_ports i2c_sda]

# Note: For Xilinx, true open-drain is modeled via IOB=TRUE + OBUFT in RTL,
# or by using the IP integrator I2C configuration. In pure XDC, the above
# drive/slew settings are the minimum to set.


# False Path — the core I2C timing constraint
#
# I2C runs at ≤1 MHz. Your FPGA clock is likely 50-200 MHz.
# The timing tool has no idea when I2C transitions happen relative to your clock,
# and cannot analyze this path meaningfully.
#
# Apply set_false_path to both directions on both signals:
#
set_false_path -from [get_ports i2c_scl]
set_false_path -from [get_ports i2c_sda]
set_false_path -to   [get_ports i2c_scl]
set_false_path -to   [get_ports i2c_sda]

#
# Because SDA is bidirectional, you need false path in BOTH directions.
# In your HDL, you likely have separate sda_in and sda_out signals with a tristate:
#   assign i2c_sda = sda_oe ? sda_out : 1'bz;
# The false path applies to both the input reading and the output driving.


# Input Synchronizer Reminder
#
# Even though we apply false_path, your RTL MUST still synchronize the I2C inputs
# with a 2-FF synchronizer to prevent metastability. The false_path just tells
# Vivado's timing tool to stop analyzing — it does NOT eliminate metastability.
#
# Minimal synchronizer (add to your Verilog/VHDL):
#   (* ASYNC_REG = "TRUE" *) reg [1:0] scl_sync;
#   (* ASYNC_REG = "TRUE" *) reg [1:0] sda_sync;
#   always @(posedge clk) begin
#     scl_sync <= {scl_sync[0], i2c_scl};
#     sda_sync <= {sda_sync[0], i2c_sda};
#   end
#   wire scl_synced = scl_sync[1];
#   wire sda_synced = sda_sync[1];
#
# The ASYNC_REG attribute tells Vivado to place these flip-flops close together
# to minimize metastability settling time.


