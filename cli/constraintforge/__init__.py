"""ConstraintForge: Pre-Synthesis Structural Diagnostic Engine."""

__version__ = "0.1.0"

from .analyzer import build_graph, analyze_logic_depth, analyze_fanout
from .reporter import print_report, print_depth_report, print_fanout_report
from .yosys_runner import generate_netlist

__all__ = [
    "__version__",
    "build_graph",
    "analyze_logic_depth",
    "analyze_fanout",
    "print_report",
    "print_depth_report",
    "print_fanout_report",
    "generate_netlist",
]
