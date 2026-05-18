# ---
# GENERATED CLOCK CONSTRAINTS — PLL  —  Intel Quartus Prime (.sdc)
# ---
#
# In Quartus, the recommended approach for PLL-generated clocks is:
#   derive_pll_clocks
#
# This single command automatically introspects ALL PLL instances in your design
# and creates correct generated clock constraints for every output. It is
# superior to manually writing create_generated_clock for each output.
#
# ALWAYS use derive_pll_clocks unless you have a specific reason not to.
# Place it AFTER all create_clock (primary clock) definitions.
#
# ---


# ---
# Standard SDC file structure for Quartus with PLLs
# ---

set_time_format -unit ns -decimal_places 3

# Step 1: Define all primary clocks (clocks entering from FPGA pins)
create_clock -name {sys_clk}  -period 20.000 -waveform {0.000 10.000} [get_ports {clk}]

# Step 2: Automatically generate constraints for ALL PLL outputs
# This replaces manually writing create_generated_clock for each PLL output.
# Quartus names PLL output clocks as: <pll_instance_name>|<altpll_instance>|clk[N]
derive_pll_clocks

# Step 3: Derive clock uncertainty for all clocks (jitter modeling)
derive_clock_uncertainty

# After these 3 steps, ALL clocks in your design are properly constrained.
# Proceed with set_input_delay, set_output_delay, set_false_path, etc.


# ---
# MANUAL create_generated_clock (only if derive_pll_clocks doesn't work)
# ---
#
# In rare cases (e.g., using raw PLL primitives, OpenFPGA flows, or non-standard
# clock structures), derive_pll_clocks may not find your PLL. In that case,
# manually define the generated clocks:
#
# Syntax for Quartus:
# create_generated_clock \
#   -name {pll_out_200mhz} \
#   -source [get_pins {u_pll|altpll_component|auto_generated|pll1|inclk[0]}] \
#   -multiply_by 4 \
#   -divide_by 1 \
#   [get_pins {u_pll|altpll_component|auto_generated|pll1|clk[0]}]
#
# The pin paths in Quartus use | as hierarchy separator (not / like Vivado).
# Find your exact pin paths in Quartus:
#   Compilation report → Timing Analyzer → Clocks
#   Or: quartus_sta --do_report_timing → check clock names in output


# ---
# Verifying generated clocks
# ---
#
# After compilation, open Quartus Timing Analyzer:
#   Processing → Timing Analyzer → Report Clocks
#
# Or from command line:
#   quartus_sta <project> --report_clocks
#
# Every PLL output should appear as a generated clock with the correct period.
# If a PLL output is missing, derive_pll_clocks couldn't find it.
# Use the manual method above in that case.
