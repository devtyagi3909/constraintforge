import unittest
import sys
import os
from unittest.mock import patch, MagicMock
import tempfile

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

from constraintforge.yosys_runner import generate_netlist, build_yosys_script

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

    @patch('constraintforge.yosys_runner.subprocess.run')
    def test_generate_netlist_binary_not_found(self, mock_run):
        mock_run.side_effect = FileNotFoundError("No such file or directory: 'yosys'")
        res = generate_netlist(["test.v"], "top")
        self.assertIsNone(res)

    @patch('constraintforge.yosys_runner.subprocess.run')
    def test_generate_netlist_multiple_files(self, mock_run):
        mock_run.return_value = MagicMock()
        res = generate_netlist(["file1.v", "file2.v"], "top_mod")
        self.assertIsNotNone(res)
        args, kwargs = mock_run.call_args
        self.assertIn("file1.v file2.v", args[0][2])
        if os.path.exists(res):
            os.remove(res)

    def test_build_yosys_script_single_file(self):
        script = build_yosys_script(["top.v"], "my_core", "/tmp/out.json")
        self.assertIn("read_verilog -sv top.v", script)
        self.assertIn("hierarchy -top my_core", script)
        self.assertIn("proc", script)
        self.assertIn("flatten", script)
        self.assertIn("techmap", script)
        self.assertIn("opt", script)
        self.assertIn("abc -g AND,OR,XOR", script)
        self.assertIn("write_json /tmp/out.json", script)

    def test_build_yosys_script_multiple_files(self):
        script = build_yosys_script(["a.v", "b.v", "c.sv"], "alu", "output.json")
        self.assertIn("read_verilog -sv a.v b.v c.sv", script)
        self.assertIn("hierarchy -top alu", script)
        self.assertIn("write_json output.json", script)

if __name__ == '__main__':
    unittest.main()
