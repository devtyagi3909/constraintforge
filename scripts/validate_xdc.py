#!/usr/bin/env python3
"""
validate_xdc.py — Static syntax checker for Xilinx XDC constraint files.

Checks for:
  - Required commands (create_clock present)
  - Unmatched brackets in get_ports/get_pins/get_cells expressions
  - Placeholder pin values that were never filled in (<PIN_NAME> patterns)
  - Duplicate create_clock definitions on the same port
  - set_multicycle_path without matching hold constraint
  - set_false_path on the same ports as set_input_delay (conflicting exceptions)
  - Common typos (e.g., LVCMOS3.3 instead of LVCMOS33)

Usage:
    python3 validate_xdc.py <file.xdc>
    python3 validate_xdc.py interfaces/clocks/primary-clock.xdc
    python3 validate_xdc.py --all          # Check every .xdc in the repo

Exit code: 0 = pass, 1 = warnings found, 2 = errors found
"""

import re
import sys
import os
import argparse
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Tuple


# ---------------------------------------------------------------------------
# Data structures
# ---------------------------------------------------------------------------

@dataclass
class Issue:
    severity: str   # "ERROR" | "WARNING" | "INFO"
    line: int
    message: str


@dataclass
class ValidationResult:
    filepath: str
    issues: List[Issue] = field(default_factory=list)

    @property
    def errors(self):
        return [i for i in self.issues if i.severity == "ERROR"]

    @property
    def warnings(self):
        return [i for i in self.issues if i.severity == "WARNING"]

    def passed(self):
        return len(self.errors) == 0


# ---------------------------------------------------------------------------
# Validators
# ---------------------------------------------------------------------------

def check_placeholders(lines: List[str], filepath: str) -> List[Issue]:
    """
    Flag any <PLACEHOLDER> tokens that were never replaced.

    SCOPING RULE:
      - boards/      → placeholders are ERRORS. Board files must have real pins.
      - interfaces/  → placeholders are expected by design (templates).
                       Skip this check entirely — users fill them in themselves.
      - timing-patterns/ → skip (no pin assignments, purely logical constraints)
      - scripts/     → skip
    """
    # Normalise path separators
    norm = filepath.replace("\\", "/")

    # Only enforce on board files
    if not any(seg in norm for seg in ["boards/"]):
        return []

    issues = []
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith("#"):
            continue
        placeholders = re.findall(r"<[A-Z0-9_]+>", line)
        for ph in placeholders:
            issues.append(Issue("ERROR", i,
                f"Unfilled placeholder {ph} — board files must have real pin values"))
    return issues


def check_iostandard_typos(lines: List[str]) -> List[Issue]:
    """Catch common IOSTANDARD mistakes."""
    issues = []
    bad_patterns = [
        (r"LVCMOS3\.3",  "LVCMOS33"),
        (r"LVCMOS1\.8",  "LVCMOS18"),
        (r"LVCMOS2\.5",  "LVCMOS25"),
        (r"LVCMOS1\.5",  "LVCMOS15"),
        (r"LVTTL3\.3",   "LVCMOS33"),
        (r"LVDS25",      "LVDS_25"),
        (r"DIFF_SSTL15_DCI", "DIFF_SSTL15"),  # Watch for this one
    ]
    for i, line in enumerate(lines, 1):
        if line.strip().startswith("#"):
            continue
        for pattern, suggestion in bad_patterns:
            if re.search(pattern, line, re.IGNORECASE):
                issues.append(Issue("ERROR", i,
                    f"Invalid IOSTANDARD — did you mean '{suggestion}'? Found: {line.strip()[:60]}"))
    return issues


def check_create_clock_present(lines: List[str]) -> List[Issue]:
    """Warn if a file has set_input_delay/set_output_delay but no create_clock."""
    has_clock = any("create_clock" in l or "create_generated_clock" in l
                    for l in lines if not l.strip().startswith("#"))
    has_io_delay = any(("set_input_delay" in l or "set_output_delay" in l)
                       for l in lines if not l.strip().startswith("#"))
    if has_io_delay and not has_clock:
        return [Issue("WARNING", 0,
            "File has set_input_delay/set_output_delay but no create_clock — "
            "ensure a primary clock is defined in another XDC loaded before this one")]
    return []


def check_duplicate_create_clock(lines: List[str]) -> List[Issue]:
    """Detect duplicate create_clock on the same port."""
    issues = []
    seen_ports = {}
    for i, line in enumerate(lines, 1):
        if line.strip().startswith("#"):
            continue
        if "create_clock" in line and "create_generated_clock" not in line:
            match = re.search(r"\[get_ports\s+([^\]]+)\]", line)
            if match:
                port = match.group(1).strip()
                if port in seen_ports:
                    issues.append(Issue("ERROR", i,
                        f"Duplicate create_clock on port '{port}' "
                        f"(first defined on line {seen_ports[port]})"))
                else:
                    seen_ports[port] = i
    return issues


def check_multicycle_hold_pairing(lines: List[str]) -> List[Issue]:
    """Warn if set_multicycle_path -setup N exists without matching -hold (N-1)."""
    issues = []
    setup_paths = []
    hold_paths  = []

    for i, line in enumerate(lines, 1):
        if line.strip().startswith("#"):
            continue
        if "set_multicycle_path" not in line:
            continue
        if "-setup" in line:
            m = re.search(r"-setup\s+(\d+)", line)
            if m:
                setup_paths.append((i, int(m.group(1)), line.strip()))
        if "-hold" in line:
            m = re.search(r"-hold\s+(\d+)", line)
            if m:
                hold_paths.append((i, int(m.group(1)), line.strip()))

    if setup_paths and not hold_paths:
        for lineno, n, _ in setup_paths:
            issues.append(Issue("WARNING", lineno,
                f"set_multicycle_path -setup {n} has no matching -hold {n-1} "
                f"— missing hold constraint may cause hold violations in hardware"))
    return issues


def check_false_path_io_conflict(lines: List[str]) -> List[Issue]:
    """Warn if the same port has both set_false_path and set_input/output_delay."""
    issues = []
    false_path_ports = set()
    delay_ports = set()

    for i, line in enumerate(lines, 1):
        if line.strip().startswith("#"):
            continue
        match = re.search(r"\[get_ports\s+([^\]]+)\]", line)
        if not match:
            continue
        port = match.group(1).strip()
        if "set_false_path" in line:
            false_path_ports.add(port)
        if "set_input_delay" in line or "set_output_delay" in line:
            delay_ports.add(port)

    conflicts = false_path_ports & delay_ports
    for port in conflicts:
        issues.append(Issue("WARNING", 0,
            f"Port '{port}' has both set_false_path and set_input/output_delay — "
            f"false_path overrides delay constraints (may be intentional)"))
    return issues


def check_period_values(lines: List[str]) -> List[Issue]:
    """Warn on suspicious clock periods (< 1 ns or > 200 ns)."""
    issues = []
    for i, line in enumerate(lines, 1):
        if line.strip().startswith("#"):
            continue
        if "create_clock" not in line:
            continue
        m = re.search(r"-period\s+([\d.]+)", line)
        if m:
            period = float(m.group(1))
            if period < 1.0:
                issues.append(Issue("WARNING", i,
                    f"Very short clock period {period} ns (= {1000/period:.0f} MHz) — "
                    f"verify this is intentional"))
            elif period > 200.0:
                issues.append(Issue("WARNING", i,
                    f"Very long clock period {period} ns (= {1000/period:.2f} MHz) — "
                    f"is this correct?"))
    return issues


def check_unbalanced_brackets(lines: List[str]) -> List[Issue]:
    """Check for unmatched [ ] in get_* expressions."""
    issues = []
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith("#"):
            continue
        opens  = stripped.count("[")
        closes = stripped.count("]")
        if opens != closes:
            issues.append(Issue("ERROR", i,
                f"Unbalanced brackets: {opens} '[' vs {closes} ']' — "
                f"check get_ports/get_pins/get_cells expression"))
    return issues


# ---------------------------------------------------------------------------
# Main validation runner
# ---------------------------------------------------------------------------

LINE_CHECKS = [
    check_iostandard_typos,
    check_create_clock_present,
    check_duplicate_create_clock,
    check_multicycle_hold_pairing,
    check_false_path_io_conflict,
    check_period_values,
    check_unbalanced_brackets,
]


def validate_file(filepath: str) -> ValidationResult:
    result = ValidationResult(filepath=filepath)
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            lines = f.readlines()
    except OSError as e:
        result.issues.append(Issue("ERROR", 0, f"Cannot open file: {e}"))
        return result

    # Placeholder check is filepath-aware (only boards/ enforced)
    result.issues.extend(check_placeholders(lines, filepath))

    for check in LINE_CHECKS:
        result.issues.extend(check(lines))

    return result


def print_result(result: ValidationResult) -> None:
    status = "✅ PASS" if result.passed() else "❌ FAIL"
    print(f"\n{status}  {result.filepath}")

    for issue in sorted(result.issues, key=lambda x: x.line):
        loc = f"line {issue.line}" if issue.line > 0 else "file"
        icon = {"ERROR": "🔴", "WARNING": "🟡", "INFO": "🔵"}.get(issue.severity, "·")
        print(f"  {icon} [{issue.severity}] {loc}: {issue.message}")

    if not result.issues:
        print("  No issues found.")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def find_all_xdc(repo_root: str) -> List[str]:
    """Recursively find all .xdc files under repo_root."""
    return [str(p) for p in Path(repo_root).rglob("*.xdc")]


def main():
    parser = argparse.ArgumentParser(
        description="Validate XDC constraint files for common mistakes."
    )
    parser.add_argument("files", nargs="*", help="XDC files to validate")
    parser.add_argument("--all", action="store_true",
                        help="Validate all .xdc files in the repository")
    parser.add_argument("--root", default=".",
                        help="Repository root (used with --all), default: current dir")
    args = parser.parse_args()

    if args.all:
        files = find_all_xdc(args.root)
        if not files:
            print(f"No .xdc files found under {args.root}")
            sys.exit(0)
    elif args.files:
        files = args.files
    else:
        parser.print_help()
        sys.exit(0)

    results = [validate_file(f) for f in files]

    total_errors   = sum(len(r.errors)   for r in results)
    total_warnings = sum(len(r.warnings) for r in results)
    passed         = sum(1 for r in results if r.passed())

    for r in results:
        print_result(r)

    print(f"\n{'='*60}")
    print(f"Checked {len(results)} file(s): "
          f"{passed} passed, {len(results)-passed} failed")
    print(f"Errors: {total_errors}  Warnings: {total_warnings}")

    if total_errors > 0:
        sys.exit(2)
    elif total_warnings > 0:
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == "__main__":
    main()
