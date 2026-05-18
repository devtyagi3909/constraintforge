#!/usr/bin/env bash
# ==============================================================================
# check_all.sh — Run all constraint validators across the repo
#
# Usage:
#   ./scripts/check_all.sh              # Check everything
#   ./scripts/check_all.sh --xdc-only   # Only check .xdc files
#   ./scripts/check_all.sh --sdc-only   # Only check .sdc files
#
# Exit code: 0 = all pass, 1 = warnings, 2 = errors
# ==============================================================================

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_DIR="$REPO_ROOT/scripts"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'  # No Color

echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║     FPGA Constraint Library — Validation Suite       ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
XDC_CHECK=true
SDC_CHECK=true
LPF_CHECK=true

for arg in "$@"; do
    case $arg in
        --xdc-only) SDC_CHECK=false; LPF_CHECK=false ;;
        --sdc-only) XDC_CHECK=false; LPF_CHECK=false ;;
        --lpf-only) XDC_CHECK=false; SDC_CHECK=false ;;
        --help|-h)
            echo "Usage: $0 [--xdc-only|--sdc-only|--lpf-only]"
            exit 0 ;;
    esac
done

# ---------------------------------------------------------------------------
# Helper: count files
# ---------------------------------------------------------------------------
count_files() {
    find "$REPO_ROOT" -name "$1" -not -path "*/.git/*" | wc -l | tr -d ' '
}

XDC_COUNT=$(count_files "*.xdc")
SDC_COUNT=$(count_files "*.sdc")
LPF_COUNT=$(count_files "*.lpf")

echo -e "${BLUE}Found:${NC} ${XDC_COUNT} .xdc | ${SDC_COUNT} .sdc | ${LPF_COUNT} .lpf"
echo ""

OVERALL_EXIT=0

# ---------------------------------------------------------------------------
# XDC Validation (Python)
# ---------------------------------------------------------------------------
if [ "$XDC_CHECK" = "true" ]; then
    echo -e "${BOLD}── XDC Files (Vivado) ────────────────────────────────${NC}"
    if ! command -v python3 &>/dev/null; then
        echo -e "${YELLOW}⚠ python3 not found — skipping XDC validation${NC}"
    else
        python3 "$SCRIPT_DIR/validate_xdc.py" --all --root "$REPO_ROOT"
        XDC_EXIT=$?
        if [ $XDC_EXIT -gt $OVERALL_EXIT ]; then OVERALL_EXIT=$XDC_EXIT; fi
    fi
    echo ""
fi

# ---------------------------------------------------------------------------
# SDC Validation (Tcl)
# ---------------------------------------------------------------------------
if [ "$SDC_CHECK" = "true" ]; then
    echo -e "${BOLD}── SDC Files (Quartus) ───────────────────────────────${NC}"
    if ! command -v tclsh &>/dev/null; then
        echo -e "${YELLOW}⚠ tclsh not found — skipping SDC validation${NC}"
        echo -e "  Install: sudo apt install tcl  OR  brew install tcl-tk"
    else
        tclsh "$SCRIPT_DIR/validate_sdc.tcl" --all
        SDC_EXIT=$?
        if [ $SDC_EXIT -gt $OVERALL_EXIT ]; then OVERALL_EXIT=$SDC_EXIT; fi
    fi
    echo ""
fi

# ---------------------------------------------------------------------------
# LPF Basic check (bash — no external tool needed)
# ---------------------------------------------------------------------------
if [ "$LPF_CHECK" = "true" ]; then
    echo -e "${BOLD}── LPF Files (Lattice/nextpnr) ───────────────────────${NC}"
    LPF_ERRORS=0
    while IFS= read -r -d '' lpf_file; do
        ISSUES=()
        # Check for unfilled placeholders
        while IFS= read -r line; do
            if echo "$line" | grep -qE '<[A-Z0-9_]+>' 2>/dev/null; then
                ph=$(echo "$line" | grep -oE '<[A-Z0-9_]+>')
                ISSUES+=("ERROR: Unfilled placeholder $ph")
            fi
        done < "$lpf_file"

        rel_path="${lpf_file#$REPO_ROOT/}"
        if [ ${#ISSUES[@]} -eq 0 ]; then
            echo -e "  ✅ $rel_path"
        else
            echo -e "  ❌ $rel_path"
            for issue in "${ISSUES[@]}"; do
                echo -e "     🔴 $issue"
                ((LPF_ERRORS++))
            done
        fi
    done < <(find "$REPO_ROOT" -name "*.lpf" -not -path "*/.git/*" -print0)

    if [ $LPF_ERRORS -gt 0 ] && [ $OVERALL_EXIT -lt 2 ]; then
        OVERALL_EXIT=2
    fi
    echo ""
fi

# ---------------------------------------------------------------------------
# Structure check — ensure README exists in each interface/board directory
# ---------------------------------------------------------------------------
echo -e "${BOLD}── Structure Check ───────────────────────────────────${NC}"
MISSING_READMES=0
for dir in "$REPO_ROOT"/interfaces/*/  "$REPO_ROOT"/boards/*/*/; do
    if [ ! -f "$dir/README.md" ]; then
        rel="${dir#$REPO_ROOT/}"
        echo -e "  ${YELLOW}⚠ Missing README.md in ${rel}${NC}"
        ((MISSING_READMES++))
    fi
done
if [ $MISSING_READMES -eq 0 ]; then
    echo -e "  ${GREEN}✅ All interface/board directories have README.md${NC}"
fi
echo ""

# ---------------------------------------------------------------------------
# Final summary
# ---------------------------------------------------------------------------
echo -e "${BOLD}══════════════════════════════════════════════════════${NC}"
case $OVERALL_EXIT in
    0) echo -e "${GREEN}${BOLD}✅ ALL CHECKS PASSED${NC}" ;;
    1) echo -e "${YELLOW}${BOLD}⚠  PASSED WITH WARNINGS${NC}" ;;
    2) echo -e "${RED}${BOLD}❌ VALIDATION FAILED — fix errors before merging${NC}" ;;
esac
echo -e "${BOLD}══════════════════════════════════════════════════════${NC}"

exit $OVERALL_EXIT
