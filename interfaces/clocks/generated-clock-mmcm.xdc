# ---
# GENERATED CLOCK CONSTRAINTS — MMCM / PLL  —  Xilinx Vivado (.xdc)
# ---
#
# A "generated clock" is a clock derived from a primary clock by
# an internal resource — typically an MMCM (Mixed-Mode Clock Manager) or PLL
# (Phase-Locked Loop). Generated clocks must be defined with create_generated_clock
# so Vivado knows their relationship to the primary clock.
#
# IMPORTANT RULE:
#   - Never use create_clock for MMCM/PLL outputs — use create_generated_clock
#   - The -source pin must be the INPUT pin of the MMCM (the pin the primary
#     clock feeds into), NOT the output net
#   - Define the primary clock FIRST (in primary-clock.xdc), THEN these
#
# HOW TO FIND YOUR MMCM PIN PATH:
#   In Vivado Tcl Console after synthesis/implementation:
#     get_cells -hierarchical -filter {REF_NAME =~ MMCM*}
#     # This lists all MMCM/PLL instance names
#     get_pins your_mmcm_inst/CLKIN1
#     # This gives you the exact path to use in -source
#
# ---


# ---
# EXAMPLE 1: MMCM with 2 outputs — 200 MHz and 50 MHz
# ---
#
# Scenario:
#   Input:   sys_clk = 100 MHz (defined in primary-clock.xdc)
#   Output0: clk_200 = 200 MHz (multiply by 2)
#   Output1: clk_50  = 50 MHz  (divide by 2)
#   MMCM instance name: u_mmcm (common convention)
#
# -name clk_200       : Logical name for this generated clock
# -source             : The MMCM's input clock pin. This creates the timing
#                       relationship between the primary clock and generated clock.
#                       Path format: <instance_path>/CLKIN1
#                       Adjust for your hierarchy depth.
# -multiply_by 2      : Multiply the source clock frequency by this factor
# -divide_by 1        : Divide by this factor (default 1, can omit)
# [get_pins ...]      : The MMCM output pin — CLKOUT0, CLKOUT1, etc.
#
create_generated_clock \
    -name clk_200 \
    -source [get_pins u_mmcm/CLKIN1] \
    -multiply_by 2 \
    [get_pins u_mmcm/CLKOUT0]

create_generated_clock \
    -name clk_50 \
    -source [get_pins u_mmcm/CLKIN1] \
    -divide_by 2 \
    [get_pins u_mmcm/CLKOUT1]


# ---
# EXAMPLE 2: PLL output with phase shift
# ---
#
# Some interfaces (RGMII, source-synchronous DDR) need a phase-shifted clock.
# The -phase option specifies the shift in degrees relative to the source.
#
# Scenario:
#   Input: 125 MHz  →  Output: 125 MHz shifted by 90 degrees
#   This is common for RGMII where TX data must be center-aligned to the clock.
#
create_generated_clock \
    -name clk_125_90deg \
    -source [get_pins u_pll/CLKIN1] \
    -multiply_by 1 \
    -phase 90 \
    [get_pins u_pll/CLKOUT0]


# ---
# EXAMPLE 3: If using Vivado's Clocking Wizard IP
# ---
#
# When you instantiate the Clocking Wizard IP (clk_wiz_0), Vivado automatically
# generates a constraints file (clk_wiz_0.xdc) that defines all generated clocks.
# You should INCLUDE that file rather than writing your own — it uses the exact
# internal pin paths for your specific configuration.
#
# However, if you are NOT using the IP but writing your own MMCM primitive
# instantiation, you MUST define generated clocks manually as shown above.
#
# To include the IP's constraints file:
#   read_xdc [get_files -of_objects [get_filesets constrs_1] -filter {NAME =~ *clk_wiz*}]
#
# Or simply add the auto-generated XDC from the IP output products to your project.


# ---
# EXAMPLE 4: Nested generated clocks (generated from a generated clock)
# ---
#
# If a clock buffer (BUFR, BUFMR) divides an MMCM output further:
#
# -source must point to the MMCM output pin (not the BUFR output)
# because that is where the timing origin is.
#
create_generated_clock \
    -name clk_25 \
    -source [get_pins u_mmcm/CLKOUT0] \
    -divide_by 4 \
    [get_pins u_bufr_inst/O]


# ---
# EXAMPLE 5: MMCM in Zynq PS (Processing System) designs
# ---
#
# The Zynq PS can output clocks to the PL (FCLK_CLK0..3). These are generated
# clocks internally — they need create_generated_clock referencing the PS cell.
#
# FCLK_CLK0 is typically the main PL clock from PS.
create_generated_clock \
    -name fclk0_100mhz \
    -source [get_pins ps7_inst/FCLKCLK[0]] \
    -master_clock [get_clocks sys_clk] \
    [get_nets fclk_clk0]


# verify:
#   In Tcl Console: report_clocks
#   Look for all your generated clock names — they should all appear.
#   If a generated clock is missing, the -source path is wrong.
