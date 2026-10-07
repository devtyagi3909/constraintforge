import unittest
import sys
import os
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

from constraintforge.main import cli

class TestMain(unittest.TestCase):
    @patch('constraintforge.main.sys.argv', ['constraintforge', 'diagnose', '--top', 'top_module', 'test.v'])
    @patch('constraintforge.main.generate_netlist')
    @patch('constraintforge.main.build_graph')
    @patch('constraintforge.main.analyze_logic_depth')
    @patch('constraintforge.main.analyze_fanout')
    @patch('constraintforge.main.print_report')
    def test_main_success(self, mock_print, mock_fanout, mock_depth, mock_graph, mock_yosys):
        mock_yosys.return_value = "dummy.json"
        mock_graph.return_value = {"dff_cells": [], "ports": {}}
        mock_depth.return_value = []
        mock_fanout.return_value = []
        
        try:
            cli()
        except SystemExit:
            pass
        
        self.assertTrue(mock_yosys.called)
        self.assertTrue(mock_graph.called)
        self.assertTrue(mock_depth.called)
        self.assertTrue(mock_fanout.called)
        self.assertTrue(mock_print.called)

    @patch('constraintforge.main.sys.argv', ['constraintforge', 'diagnose', '--top', 'top_module', 'test.v'])
    @patch('constraintforge.main.generate_netlist')
    @patch('constraintforge.main.sys.exit')
    def test_main_yosys_failure(self, mock_exit, mock_yosys):
        mock_yosys.return_value = None
        
        try:
            cli()
        except SystemExit:
            pass
            
        self.assertTrue(mock_yosys.called)
        mock_exit.assert_called_with(1)

if __name__ == '__main__':
    unittest.main()
