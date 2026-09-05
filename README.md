# constraintforge

Timing constraints are the part nobody talks about until your design fails timing at 2am.

The official docs are spread across Xilinx UG903, Intel AN433, a dozen app notes, and Stack Overflow answers from 2013. This repo puts everything in one place — constraint templates for every interface, annotated so you understand what each line does and why, not just that it exists.

[![CI](https://github.com/devtyagi3909/constraintforge/actions/workflows/validate-constraints.yml/badge.svg)](https://github.com/devtyagi3909/constraintforge/actions) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/devtyagi3909/constraintforge/blob/main/LICENSE) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/devtyagi3909/constraintforge/blob/main/CONTRIBUTING.md)

**[Browse the site](https://devtyagi3909.github.io/constraintforge)** | **[Timing Calculator](https://devtyagi3909.github.io/constraintforge/timing-calculator.html)** | **[AI Generator](https://devtyagi3909.github.io/constraintforge/ai-generator.html)**

<p align="center">
  <img src="assets/terminal_demo.svg" alt="ConstraintForge Terminal Demo" />
</p>

---

## Tools

### Timing Budget Calculator

You have a datasheet that says `tCO_max = 7 ns`. You're not sure whether that goes in `-max 7.0` or `-max period-7.0`. [The calculator](https://devtyagi3909.github.io/constraintforge/timing-calculator.html) takes your datasheet values — tCO, tSU, tH — works out the setup and hold slack with a visual timeline, and produces the exact `set_input_delay` / `set_output_delay` lines to paste.

### AI Constraint Generator

Paste your Verilog or VHDL top-level module. Pick your board. The generator reads every port, identifies clocks and interfaces, maps pins to your board, handles async false paths, and returns a complete annotated `.xdc` in seconds. [Try it](https://devtyagi3909.github.io/constraintforge/ai-generator.html).

---

## What's covered

### Interfaces

| Interface        | XDC | SDC | LPF | Notes                                           |
| ---------------- | --- | --- | --- | ----------------------------------------------- |
| Primary clock    | ✓   | ✓   | ✓   | Single-ended and differential                   |
| MMCM / PLL       | ✓   | ✓   | —   | Generated clocks                                |
| UART             | ✓   | ✓   | ✓   | False path — it's async, stop trying to time it |
| SPI master       | ✓   | ✓   | ✓   | Generated SCLK, source-synchronous              |
| SPI slave        | ✓   | ✓   | —   | Incoming SCLK as primary clock + CDC            |
| I2C              | ✓   | ✓   | ✓   | Open-drain, both directions false path          |
| DDR3             | ✓   | ✓   | —   | MIG/EMIF guidance and what you add yourself     |
| LVDS             | ✓   | ✓   | ✓   | Source-synchronous, SDR + DDR, DIFF_TERM        |
| HDMI (TMDS)      | ✓   | ✓   | —   | Pixel clock MMCM, false path on outputs         |
| Ethernet (RGMII) | ✓   | ✓   | —   | 125 MHz DDR, both clock edges                   |
| MIPI CSI-2 RX    | ✓   | ✓   | —   | Camera interface, D-PHY clock, CDC              |
| AXI4-Lite        | ✓   | ✓   | —   | Synchronous bus, async reset, multi-clock       |
| I2S audio        | ✓   | ✓   | —   | Master and slave modes, BCLK generated clock    |
| Virtual clocks   | ✓   | ✓   | —   | The one everyone gets wrong                     |

### Timing patterns

| Pattern                                  | XDC | SDC |
| ---------------------------------------- | --- | --- |
| Clock domain crossing (CDC)              | ✓   | ✓   |
| Multicycle path                          | ✓   | ✓   |
| False path                               | ✓   | ✓   |
| I/O delays (system and source-synchronous) | ✓   | ✓   |

### Boards

| Board               | Device       | File                                                                                                                        |
| ------------------- | ------------ | --------------------------------------------------------------------------------------------------------------------------- |
| Basys 3             | XC7A35T      | [basys3.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/basys3/basys3.xdc)                    |
| Arty A7-100T        | XC7A100T     | [arty-a7-100t.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/arty-a7-100t/arty-a7-100t.xdc) |
| Nexys A7-100T       | XC7A100T     | [nexys-a7-100t.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/nexys-a7-100t/nexys-a7-100t.xdc) |
| Zybo Z7-20          | XC7Z020      | [zybo-z7-20.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/zybo-z7-20/zybo-z7-20.xdc)       |
| PYNQ-Z2             | XC7Z020      | [pynq-z2.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/pynq-z2/pynq-z2.xdc)                |
| Cmod A7-35T         | XC7A35T      | [cmod-a7-35t.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/cmod-a7-35t/cmod-a7-35t.xdc)   |
| Boolean Board       | XC7A35T      | [boolean.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/boolean/boolean.xdc)                |
| ZCU104              | XCZU7EV      | [zcu104.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/zcu104/zcu104.xdc)                   |
| Alveo U50           | XCU50        | [alveo-u50.xdc](https://github.com/devtyagi3909/constraintforge/blob/main/boards/xilinx/alveo-u50/alveo-u50.xdc)          |
| DE10-Nano           | 5CSEBA6U23I7 | [de10-nano/](https://github.com/devtyagi3909/constraintforge/blob/main/boards/intel/de10-nano)                             |
| DE1-SoC             | 5CSEMA5F31C6 | [de1-soc/](https://github.com/devtyagi3909/constraintforge/blob/main/boards/intel/de1-soc)                                |
| iCE40-HX8K Breakout | iCE40HX8K    | [ice40-hx8k.lpf](https://github.com/devtyagi3909/constraintforge/blob/main/boards/lattice/ice40-hx8k/ice40-hx8k.lpf)     |
| ULX3S (ECP5)        | LFE5U-85F    | [ecp5.lpf](https://github.com/devtyagi3909/constraintforge/blob/main/boards/lattice/ecp5/ecp5.lpf)                        |
| Tang Nano 9K        | GW1NR-9C     | [tang-nano-9k/](https://github.com/devtyagi3909/constraintforge/blob/main/boards/gowin/tang-nano-9k)                      |

---

## How to use it

Find your interface. Open the file for your toolchain. The comments explain the timing model and which values you need from your peripheral's datasheet. Copy the constraints into your project and rename the ports to match yours.

For board files: uncomment only the pins you actually use. `PACKAGE_PIN` values are verified against schematics — don't modify them. Only rename the port inside `get_ports {}`.

**Vivado:**

```tcl
read_xdc interfaces/clocks/primary-clock.xdc
read_xdc interfaces/uart/uart.xdc
```

**Quartus (.qsf):**

```tcl
set_global_assignment -name SDC_FILE interfaces/clocks/primary-clock.sdc
```

**nextpnr:**

```sh
nextpnr-ice40 --hx8k --package ct256 \
  --lpf boards/lattice/ice40-hx8k/ice40-hx8k.lpf \
  --json design.json --asc out.asc
```

---

## Contributing

The fastest way to help: add a board you own that isn't listed yet. It's one `.xdc` file, CI validates it on the PR, and it gets merged quickly. See [CONTRIBUTING.md](https://github.com/devtyagi3909/constraintforge/blob/main/CONTRIBUTING.md).

---

## License

MIT.