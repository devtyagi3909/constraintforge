import unittest
import sys
import os
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

from constraintforge.reporter import print_report

class TestReporter(unittest.TestCase):
    @patch('constraintforge.reporter.console.print')
    def test_print_report_empty(self, mock_print):
        print_report([], [], "top_module", 30, 100)
        self.assertTrue(mock_print.called)
        
    @patch('constraintforge.reporter.console.print')
    def test_print_report_with_data(self, mock_print):
        paths = [{'depth': 40, 'source': 'foo.v:10', 'sink': 'bar.v:20'}]
        fanouts = [{'fanout': 150, 'register': 'reg1'}]
        print_report(paths, fanouts, "top_module", 30, 100)
        self.assertTrue(mock_print.called)

    @patch('constraintforge.reporter.console.print')
    def test_print_depth_report(self, mock_print):
        from constraintforge.reporter import print_depth_report
        paths = [{'depth': 40, 'source': 'foo.v:10', 'sink': 'bar.v:20'}]
        print_depth_report(paths, 30)
        self.assertTrue(mock_print.called)

    @patch('constraintforge.reporter.console.print')
    def test_print_fanout_report(self, mock_print):
        from constraintforge.reporter import print_fanout_report
        fanouts = [{'fanout': 150, 'register': 'reg1'}]
        print_fanout_report(fanouts, 100)
        self.assertTrue(mock_print.called)

if __name__ == '__main__':
    unittest.main()
