# ---
# AXI4-LITE TIMING CONSTRAINTS  —  Xilinx Vivado (.xdc)
# ---
#
# AXI4-Lite is a simplified subset of ARM's AMBA AXI4 bus protocol.
# It is the de-facto standard interconnect in Xilinx IP Integrator (Block Design)
# and is used by virtually every Xilinx IP core for control/status registers.
#
# TIMING MODEL:
#   AXI4-Lite signals are SYSTEM-SYNCHRONOUS — all signals are clocked by the
#   same axi_aclk. There is no source-synchronous clock. All signal transitions
#   are registered flip-flop outputs.
#
# WHAT THIS MEANS FOR CONSTRAINTS:
#   1. All AXI4-Lite signals are internal, registered paths → Vivado handles
#      them automatically once create_clock is defined for axi_aclk.
#   2. No set_input_delay or set_output_delay needed for AXI signals that
#      stay inside the FPGA (between IPs and your logic).
#   3. Timing exceptions are only needed for:
#      a) CDC between different AXI clock domains
#      b) Reset signals (axi_aresetn) crossing domains
#      c) Multicycle paths in your custom AXI slave logic (if intentional)
#
# WHEN USING IP INTEGRATOR (BLOCK DESIGN):
#   Vivado generates correct timing constraints for all IP-to-IP AXI connections
#   automatically. You generally do NOT need to manually constrain AXI4-Lite.
#
#   This file documents:
#   - The constraints you need for CUSTOM AXI4-Lite slave/master IP
#   - CDC patterns for multi-clock AXI systems
#   - Performance optimization techniques
#
# ---


# AXI4-Lite Clock
#
# In most designs, axi_aclk comes from:
#   a) The Zynq PS FCLK_CLK0 → defined automatically by PS7 IP constraints
#   b) A Vivado Clocking Wizard output → defined by the IP's XDC
#   c) An external clock pin → define it here
#
# If axi_aclk comes from an external pin (uncommon but possible):
# create_clock -period 10.000 -name axi_aclk [get_ports axi_aclk]
#
# In most Vivado block designs, the clock is already constrained by the source IP.
# Only add create_clock here if you're NOT using IP Integrator.

# For custom RTL designs (not IP Integrator):
create_clock -period 10.000 -name axi_aclk [get_ports s_axi_aclk]


# AXI Reset (axi_aresetn) — Always False Path
#
# axi_aresetn is an asynchronous active-low reset. It is driven by a reset
# controller or directly from a button/power-on circuit. It must be a false path.
#
# Your AXI slave RTL should synchronize aresetn to the AXI clock before use:
#   (* ASYNC_REG = "TRUE" *) reg [1:0] rst_sync;
#   always @(posedge aclk or negedge aresetn)
#     if (!aresetn) rst_sync <= 2'b00;
#     else          rst_sync <= {rst_sync[0], 1'b1};
#   wire rst_n_synced = rst_sync[1];

set_false_path -from [get_ports s_axi_aresetn]


# Multi-Clock AXI Systems (CDC)
#
# In systems with multiple AXI clocks (e.g., a 200 MHz AXI4 data path and
# a 100 MHz AXI4-Lite control path), you must declare them asynchronous.
#
# Use AXI Clock Converter IP to bridge between AXI clock domains safely.
# The Clock Converter IP generates correct CDC constraints. If you build
# your own bridge, declare the clock groups:

set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks axi_aclk] \
    -group [get_clocks -include_generated_clocks axi_fast_clk]


# Custom AXI4-Lite Slave — Multicycle Paths
#
# When your AXI4-Lite slave has slow configuration registers that feed complex
# combinational logic (e.g., a wide multiplier driven by a config register),
# use multicycle paths as normal. The AXI clock domain is the reference.
#
# Example: Config register → complex decoder → 2 cycles allowed
set_multicycle_path -setup 2 \
    -from [get_cells {u_axi_slave/cfg_reg[*]}] \
    -to   [get_cells {u_axi_slave/decode_reg[*]}]

set_multicycle_path -hold 1 \
    -from [get_cells {u_axi_slave/cfg_reg[*]}] \
    -to   [get_cells {u_axi_slave/decode_reg[*]}]


# AXI4 Performance Timing — RREADY / WREADY Path
#
# A common performance issue: a long combinational path from ARVALID/AWVALID
# to ARREADY/AWREADY in a custom slave. If your slave logic is complex,
# register the ready signals (add a pipeline register) rather than applying
# a multicycle path — this ensures correct AXI handshake protocol behavior.
#
# DO NOT apply set_false_path to any AXI handshake signals (VALID, READY, etc.)
# These are synchronous registered signals and MUST be timed correctly.


# AXI4-Lite in a Custom RTL Design (not IP Integrator)
#
# If you are building AXI4-Lite slaves/masters in pure RTL (not block design),
# the constraints are simply:
#   1. create_clock on the AXI clock source (done in Section 1)
#   2. set_false_path on axi_aresetn (done in Section 2)
#   3. Any multicycle paths in your slave logic (Section 4 pattern)
#   4. set_clock_groups if multiple AXI clocks (Section 3)
#
# No I/O delays are needed — AXI is fully internal to the FPGA.


# ---
# QUICK DIAGNOSTIC — Run these after implementation:
#
#   report_timing -from [get_cells u_axi_slave/*] -delay_type max
#   → Check: all AXI paths meet timing with positive slack
#
#   report_cdc -details
#   → Check: no unhandled CDC paths on AXI interfaces
#
#   check_cdc -problem_types all
#   → Should be 0 violations if clock groups are set correctly
