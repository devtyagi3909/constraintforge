# ConstraintForge CLI

A pre-synthesis structural timing diagnostic engine for Verilog and SystemVerilog.

ConstraintForge parses raw RTL into an AST, builds a Directed Acyclic Graph (DAG) of your logic, and runs a modified Depth-First Search to accurately estimate combinational logic depth and fanout. It flags setup time violations and routing bottlenecks *before* you run synthesis.

## Requirements
- Python 3.10+
- [Yosys](https://yosyshq.net/yosys/) (Must be installed and available in `$PATH`)

## Installation

```bash
pip install constraintforge
```

## Usage

```bash
constraintforge diagnose src/*.v --top top_module --max-depth 20 --max-fanout 50
```
