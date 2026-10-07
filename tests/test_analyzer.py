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
        self.assertFalse(is_dff("LUT4"))
        self.assertFalse(is_dff("PORT"))

if __name__ == '__main__':
    unittest.main()
