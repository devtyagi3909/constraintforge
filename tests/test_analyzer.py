import unittest
import sys
import os

# Add the cli package to path for testing
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

from constraintforge.analyzer import is_dff

class TestAnalyzer(unittest.TestCase):
    """Test suite for the analyzer module."""
    def test_is_dff(self):
        self.assertTrue(is_dff("$_DFF_P_"))
        self.assertTrue(is_dff("$dff"))
        self.assertTrue(is_dff("$_DFF_NN0_"))
        self.assertTrue(is_dff("$_DFF_N_"))
        self.assertTrue(is_dff("$dffe"))
        self.assertFalse(is_dff("LUT4"))
        self.assertFalse(is_dff("PORT"))
        self.assertFalse(is_dff("$_AND_"))
        self.assertFalse(is_dff("INV"))
        self.assertFalse(is_dff(""))
        
    def test_get_nice_name(self):
        from constraintforge.analyzer import get_nice_name
        cells = {
            "cell1": {"attributes": {"src": "file.v:10"}},
            "cell2": {}
        }
        self.assertEqual(get_nice_name("PORT_IN:clk", cells), "PORT_IN:clk")
        self.assertEqual(get_nice_name("cell1", cells), "file.v:10 (Reg)")
        self.assertEqual(get_nice_name("cell2", cells), "cell2")
        self.assertEqual(get_nice_name("unknown_cell", cells), "unknown_cell")

    def test_build_graph_empty_modules(self):
        import tempfile
        import json
        from constraintforge.analyzer import build_graph
        with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
            json.dump({"modules": {}}, f)
            temp_path = f.name
        try:
            self.assertIsNone(build_graph(temp_path))
        finally:
            if os.path.exists(temp_path):
                os.remove(temp_path)

    def test_build_graph_with_top_module(self):
        import tempfile
        import json
        from constraintforge.analyzer import build_graph
        netlist_data = {
            "modules": {
                "sub_mod": {
                    "ports": {"a": {"direction": "input", "bits": [2]}},
                    "cells": {}
                },
                "target_top": {
                    "ports": {"clk": {"direction": "input", "bits": [3]}},
                    "cells": {
                        "dff1": {
                            "type": "$_DFF_P_",
                            "connections": {"D": [3], "Q": [4]},
                            "port_directions": {"D": "input", "Q": "output"}
                        }
                    }
                }
            }
        }
        with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
            json.dump(netlist_data, f)
            temp_path = f.name
        try:
            graph = build_graph(temp_path, top_module="target_top")
            self.assertIsNotNone(graph)
            self.assertIn("dff1", graph["dff_cells"])
            self.assertIn("clk", graph["ports"])

            fallback_graph = build_graph(temp_path, top_module="unknown_mod")
            self.assertIsNotNone(fallback_graph)
            self.assertIn("a", fallback_graph["ports"])
        finally:
            if os.path.exists(temp_path):
                os.remove(temp_path)

    def test_analyze_fanout_empty(self):
        from constraintforge.analyzer import analyze_fanout
        empty_graph = {
            "bit_driver": {},
            "cell_inputs": {},
            "cells": {},
            "dff_cells": [],
            "ports": {}
        }
        res = analyze_fanout(empty_graph, max_fanout=10)
        self.assertEqual(res, [])

    def test_analyze_logic_depth_empty(self):
        from constraintforge.analyzer import analyze_logic_depth
        empty_graph = {
            "bit_driver": {},
            "cell_inputs": {},
            "cells": {},
            "dff_cells": [],
            "ports": {}
        }
        res = analyze_logic_depth(empty_graph, max_depth=20)
        self.assertEqual(res, [])

    def test_deduplicate_paths(self):
        from constraintforge.analyzer import deduplicate_paths
        raw_paths = [
            {"source": "regA", "sink": "regB", "depth": 15},
            {"source": "regA", "sink": "regB", "depth": 12},  # duplicate
            {"source": "regC", "sink": "regD", "depth": 10},
            {"source": "regE", "sink": "regF", "depth": 8},
        ]
        deduped = deduplicate_paths(raw_paths, limit=2)
        self.assertEqual(len(deduped), 2)
        self.assertEqual(deduped[0]["depth"], 15)
        self.assertEqual(deduped[1]["source"], "regC")

        # Test empty
        self.assertEqual(deduplicate_paths([]), [])

    def test_analyze_logic_depth_traversal(self):
        from constraintforge.analyzer import analyze_logic_depth
        # Graph topology: PORT_IN:din (bit 1) -> c_and (bit 2) -> c_or (bit 3) -> dff1
        graph = {
            "bit_driver": {
                1: "PORT_IN:din",
                2: "c_and",
                3: "c_or",
            },
            "cell_inputs": {
                "c_and": [1],
                "c_or": [2],
                "dff1": [3],
            },
            "cells": {
                "c_and": {"type": "$_AND_"},
                "c_or": {"type": "$_OR_"},
                "dff1": {"type": "$_DFF_P_"},
            },
            "dff_cells": ["dff1"],
            "ports": {
                "din": {"direction": "input", "bits": [1]},
                "dout": {"direction": "output", "bits": [3]},
            }
        }

        # Threshold of 2 should flag both dff1 and dout (depth 2)
        results = analyze_logic_depth(graph, max_depth=2)
        self.assertEqual(len(results), 2)
        sinks = {r["sink"] for r in results}
        self.assertIn("dff1", sinks)
        self.assertIn("PORT_OUT:dout", sinks)
        for r in results:
            self.assertEqual(r["depth"], 2)
            self.assertEqual(r["source"], "PORT_IN:din")

        # Threshold of 3 should flag nothing
        self.assertEqual(analyze_logic_depth(graph, max_depth=3), [])

if __name__ == '__main__':
    unittest.main()
