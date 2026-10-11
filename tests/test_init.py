import unittest
import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

import constraintforge

class TestInit(unittest.TestCase):
    """Test suite for top-level package metadata and exports."""
    def test_version_defined(self):
        self.assertTrue(hasattr(constraintforge, "__version__"))
        self.assertIsInstance(constraintforge.__version__, str)
        self.assertEqual(constraintforge.__version__, "0.1.0")

    def test_public_api_exports(self):
        expected_symbols = [
            "__version__",
            "build_graph",
            "analyze_logic_depth",
            "analyze_fanout",
            "print_report",
            "print_depth_report",
            "print_fanout_report",
            "generate_netlist",
        ]
        self.assertEqual(set(constraintforge.__all__), set(expected_symbols))
        for symbol in expected_symbols:
            self.assertTrue(hasattr(constraintforge, symbol), f"Missing symbol {symbol}")
            self.assertIsNotNone(getattr(constraintforge, symbol))

if __name__ == '__main__':
    unittest.main()
