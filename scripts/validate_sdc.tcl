#!/usr/bin/env tclsh
# ==============================================================================
# validate_sdc.tcl — SDC constraint file syntax checker
#
# Usage (standalone tclsh):
#   tclsh validate_sdc.tcl <file.sdc>
#   tclsh validate_sdc.tcl --all
#
# Usage (inside Quartus Tcl console):
#   source scripts/validate_sdc.tcl
#   validate_sdc interfaces/uart/uart.sdc
#
# Checks:
#   - set_time_format present at top
#   - Placeholder <PIN_NAME> tokens
#   - create_clock present when set_input/output_delay used
#   - Unbalanced braces { }
#   - set_multicycle_path -setup without matching -hold
# ==============================================================================

set errors 0
set warnings 0

proc report {severity lineno msg} {
    global errors warnings
    set severity_icons [dict create ERROR "🔴" WARNING "🟡" INFO "🔵"]
    if {[dict exists $severity_icons $severity]} {
        set icon [dict get $severity_icons $severity]
    } else {
        set icon "·"
    }
    if {$lineno > 0} {
        puts "  $icon \[$severity\] line $lineno: $msg"
    } else {
        puts "  $icon \[$severity\] file: $msg"
    }
    if {$severity eq "ERROR"}   { incr ::errors }
    if {$severity eq "WARNING"} { incr ::warnings }
}

proc validate_sdc {filepath} {
    global errors warnings
    set errors 0
    set warnings 0

    if {![file exists $filepath]} {
        puts "ERROR: File not found: $filepath"
        return 2
    }

    set fh [open $filepath r]
    set lines [split [read $fh] "\n"]
    close $fh

    puts "\nValidating: $filepath"

    set has_time_format  0
    set has_create_clock 0
    set has_io_delay     0
    set setup_mcp_lines  {}
    set hold_mcp_lines   {}

    set lineno 0
    foreach line $lines {
        incr lineno
        set trimmed [string trim $line]

        # Skip comment lines
        if {[string index $trimmed 0] eq "#"} { continue }
        if {$trimmed eq ""} { continue }

        # Check set_time_format
        if {[string match "*set_time_format*" $trimmed]} {
            set has_time_format 1
        }

        # Check create_clock
        if {[string match "*create_clock*" $trimmed]} {
            set has_create_clock 1
        }

        # Check I/O delays
        if {[string match "*set_input_delay*" $trimmed] ||
            [string match "*set_output_delay*" $trimmed]} {
            set has_io_delay 1
        }

        # Check for unfilled placeholders
        if {[regexp {<[A-Z0-9_]+>} $trimmed placeholder]} {
            report ERROR $lineno "Unfilled placeholder $placeholder"
        }

        # Check unbalanced braces (simple count)
        set opens  [llength [lsearch -all [split $trimmed {}] "\{"]]
        set closes [llength [lsearch -all [split $trimmed {}] "\}"]]
        if {$opens != $closes} {
            report ERROR $lineno "Unbalanced braces: $opens '{' vs $closes '}'"
        }

        # Track multicycle path setup/hold
        if {[string match "*set_multicycle_path*-setup*" $trimmed]} {
            lappend setup_mcp_lines $lineno
        }
        if {[string match "*set_multicycle_path*-hold*" $trimmed]} {
            lappend hold_mcp_lines $lineno
        }

        # Catch common SDC typos
        if {[regexp -- {-period\s+([\d.]+)} $trimmed -> period]} {
            if {$period < 1.0} {
                report WARNING $lineno "Very short clock period ${period}ns ([expr {1000.0/$period}] MHz) — verify"
            }
            if {$period > 200.0} {
                report WARNING $lineno "Very long clock period ${period}ns — verify"
            }
        }
    }

    # File-level checks
    if {!$has_time_format} {
        report WARNING 0 "Missing set_time_format — add 'set_time_format -unit ns -decimal_places 3' at top"
    }

    if {$has_io_delay && !$has_create_clock} {
        report WARNING 0 "set_input/output_delay present without create_clock in this file — ensure clock is defined in another .sdc loaded first"
    }

    if {[llength $setup_mcp_lines] > 0 && [llength $hold_mcp_lines] == 0} {
        foreach ln $setup_mcp_lines {
            report WARNING $ln "set_multicycle_path -setup found without matching -hold — add -hold (N-1) to prevent hold violations"
        }
    }

    # Summary
    if {$errors == 0 && $warnings == 0} {
        puts "  ✅ No issues found."
        return 0
    } else {
        set status [expr {$errors > 0 ? "❌ FAIL" : "⚠️  WARNINGS"}]
        puts "  $status — Errors: $errors, Warnings: $warnings"
        return [expr {$errors > 0 ? 2 : 1}]
    }
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
proc find_all_sdc {{root "."}} {
    set result {}
    foreach f [glob -nocomplain -directory $root -type f "*.sdc"] {
        lappend result $f
    }
    foreach d [glob -nocomplain -directory $root -type d "*"] {
        set result [concat $result [find_all_sdc $d]]
    }
    return $result
}

# Run when called as a script (not sourced into Quartus)
if {[info script] eq $argv0} {
    if {[llength $argv] == 0} {
        puts "Usage: tclsh validate_sdc.tcl <file.sdc> \[file2.sdc ...\]"
        puts "       tclsh validate_sdc.tcl --all"
        exit 0
    }

    if {[lindex $argv 0] eq "--all"} {
        set files [find_all_sdc "."]
    } else {
        set files $argv
    }

    set total_err 0
    set total_warn 0
    foreach f $files {
        set rc [validate_sdc $f]
        if {$rc == 2} { incr total_err }
        if {$rc == 1} { incr total_warn }
    }

    puts "\n[string repeat = 60]"
    puts "Checked [llength $files] SDC file(s)"
    puts "Files with errors: $total_err  |  Files with warnings: $total_warn"

    if {$total_err > 0} { exit 2 }
    if {$total_warn > 0} { exit 1 }
    exit 0
}
