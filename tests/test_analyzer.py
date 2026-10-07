import unittest
import sys
import os

# Add the cli package to path for testing
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

from constraintforge.analyzer import is_dff

class TestAnalyzer(unittest.TestCase):
    def test_is_dff(self):
        self.assertTrue(is_dff("$_DFF_P_"))
        self.assertTrue(is_dff("$dff"))
        self.assertTrue(is_dff("$_DFF_NN0_"))
        self.assertFalse(is_dff("LUT4"))
        self.assertFalse(is_dff("PORT"))
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

if __name__ == '__main__':
    unittest.main()
