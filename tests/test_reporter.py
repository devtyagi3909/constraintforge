import unittest
import sys
import os
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../cli')))

from constraintforge.reporter import print_report

class TestReporter(unittest.TestCase):
    """Test suite for the timing diagnostics reporter."""
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
    def test_print_depth_report_empty(self, mock_print):
        from constraintforge.reporter import print_depth_report
        print_depth_report([], 30)
        self.assertTrue(mock_print.called)

    @patch('constraintforge.reporter.console.print')
    def test_print_fanout_report(self, mock_print):
        from constraintforge.reporter import print_fanout_report
        fanouts = [{'fanout': 150, 'register': 'reg1'}]
        print_fanout_report(fanouts, 100)
        self.assertTrue(mock_print.called)

    @patch('constraintforge.reporter.console.print')
    def test_print_fanout_report_empty(self, mock_print):
        from constraintforge.reporter import print_fanout_report
        print_fanout_report([], 100)
        self.assertTrue(mock_print.called)

    def test_depth_report_table_rendering(self):
        import io
        from rich.console import Console
        from constraintforge.reporter import print_depth_report
        import constraintforge.reporter

        string_io = io.StringIO()
        test_console = Console(file=string_io, no_color=True)
        with patch.object(constraintforge.reporter, 'console', test_console):
            paths = [
                {'depth': 42, 'source': 'stage1.v:15', 'sink': 'stage2.v:30'},
                {'depth': 25, 'source': 'stage0.v:5', 'sink': 'stage1.v:10'}
            ]
            print_depth_report(paths, 20)
            output = string_io.getvalue()
            self.assertIn("CRITICAL", output)
            self.assertIn("42", output)
            self.assertIn("stage1.v:15", output)
            self.assertIn("stage2.v:30", output)
            self.assertIn("25", output)

    def test_fanout_report_table_rendering(self):
        import io
        from rich.console import Console
        import constraintforge.reporter
        from constraintforge.reporter import print_fanout_report

        string_io = io.StringIO()
        test_console = Console(file=string_io, no_color=True)
        with patch.object(constraintforge.reporter, 'console', test_console):
            fanouts = [
                {'fanout': 250, 'register': 'rst_sync_reg'},
                {'fanout': 120, 'register': 'en_gate_reg'}
            ]
            print_fanout_report(fanouts, 100)
            output = string_io.getvalue()
            self.assertIn("WARNING", output)
            self.assertIn("250", output)
            self.assertIn("rst_sync_reg", output)
            self.assertIn("120", output)

if __name__ == '__main__':
    unittest.main()
