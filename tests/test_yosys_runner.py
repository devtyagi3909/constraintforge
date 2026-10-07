import unittest
import sys
import os
from unittest.mock import patch, MagicMock
import tempfile

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

from constraintforge.yosys_runner import generate_netlist

class TestYosysRunner(unittest.TestCase):
    """Test suite for the headless Yosys execution wrapper."""
    @patch('constraintforge.yosys_runner.subprocess.run')
    def test_generate_netlist_success(self, mock_run):
        mock_run.return_value = MagicMock()
        res = generate_netlist(["test.v"], "top")
        self.assertIsNotNone(res)
        self.assertTrue(res.endswith(".json"))
        if os.path.exists(res):
            os.remove(res)
            
    @patch('constraintforge.yosys_runner.subprocess.run')
    def test_generate_netlist_failure(self, mock_run):
        import subprocess
        mock_run.side_effect = subprocess.CalledProcessError(1, 'yosys', stderr=b'error')
        res = generate_netlist(["test.v"], "top")
        self.assertIsNone(res)

if __name__ == '__main__':
    unittest.main()
