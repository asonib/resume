#!/bin/bash

# LaTeX Validation Script
# Validates .tex files for compilation errors without generating final PDF

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default file to validate
TEX_FILE="${1:-resume.tex}"

# Temporary directory for build artifacts
BUILD_DIR=".tex-validate-tmp"

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  LaTeX Validation Script${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

cleanup() {
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
}

# Set up cleanup on exit
trap cleanup EXIT

print_header

# Check if file exists
if [ ! -f "$TEX_FILE" ]; then
    print_error "File not found: $TEX_FILE"
    echo ""
    echo "Usage: $0 [filename.tex]"
    echo "Default: resume.tex"
    exit 1
fi

print_info "Validating: $TEX_FILE"
echo ""

# Check if pdflatex is installed
if ! command -v pdflatex &> /dev/null; then
    print_error "pdflatex is not installed!"
    echo ""
    echo "Please install a LaTeX distribution:"
    echo "  - Ubuntu/Debian: sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-latex-extra"
    echo "  - macOS: brew install --cask mactex-no-gui"
    echo "  - Windows: Install MiKTeX from https://miktex.org/"
    exit 1
fi

print_success "pdflatex found"

# Create temporary build directory
mkdir -p "$BUILD_DIR"

# Copy the tex file to build directory
cp "$TEX_FILE" "$BUILD_DIR/"

# Get just the filename without path
TEX_FILENAME=$(basename "$TEX_FILE")
TEX_BASENAME="${TEX_FILENAME%.tex}"

print_info "Running pdflatex validation..."
echo ""

# Run pdflatex in nonstopmode and draftmode for faster validation
# Redirect output to a variable while also saving to log
cd "$BUILD_DIR"

COMPILE_OUTPUT=$(pdflatex -interaction=nonstopmode -draftmode -halt-on-error "$TEX_FILENAME" 2>&1) || COMPILE_FAILED=1

cd - > /dev/null

LOG_FILE="$BUILD_DIR/${TEX_BASENAME}.log"

# Check compilation result
if [ "${COMPILE_FAILED:-0}" -eq 1 ]; then
    print_error "Compilation FAILED"
    echo ""
    echo -e "${RED}--- Error Details ---${NC}"
    
    # Extract error messages from log
    if [ -f "$LOG_FILE" ]; then
        # Find lines with errors
        grep -n "^!" "$LOG_FILE" | head -20 || true
        echo ""
        
        # Show context around errors
        grep -A 3 "^!" "$LOG_FILE" | head -30 || true
    else
        echo "$COMPILE_OUTPUT" | grep -i "error" | head -20 || echo "$COMPILE_OUTPUT"
    fi
    
    echo ""
    echo -e "${RED}--- End of Errors ---${NC}"
    exit 1
else
    print_success "Compilation successful (no errors)"
fi

echo ""

# Check for warnings in log file
if [ -f "$LOG_FILE" ]; then
    # Count different types of warnings
    WARNINGS=$(grep -c "LaTeX Warning" "$LOG_FILE" 2>/dev/null || echo "0")
    OVERFULL=$(grep -c "Overfull" "$LOG_FILE" 2>/dev/null || echo "0")
    UNDERFULL=$(grep -c "Underfull" "$LOG_FILE" 2>/dev/null || echo "0")
    MISSING_REFS=$(grep -c "Reference.*undefined" "$LOG_FILE" 2>/dev/null || echo "0")
    MISSING_CITATIONS=$(grep -c "Citation.*undefined" "$LOG_FILE" 2>/dev/null || echo "0")
    
    TOTAL_WARNINGS=$((WARNINGS + MISSING_REFS + MISSING_CITATIONS))
    TOTAL_BOXES=$((OVERFULL + UNDERFULL))
    
    echo -e "${BLUE}--- Validation Summary ---${NC}"
    echo ""
    
    if [ "$TOTAL_WARNINGS" -gt 0 ]; then
        print_warning "LaTeX Warnings: $WARNINGS"
        
        if [ "$MISSING_REFS" -gt 0 ]; then
            print_warning "Undefined References: $MISSING_REFS"
        fi
        
        if [ "$MISSING_CITATIONS" -gt 0 ]; then
            print_warning "Undefined Citations: $MISSING_CITATIONS"
        fi
        
        echo ""
        echo "Warning details:"
        grep "LaTeX Warning" "$LOG_FILE" | head -10 || true
        grep "Reference.*undefined" "$LOG_FILE" | head -5 || true
        grep "Citation.*undefined" "$LOG_FILE" | head -5 || true
    else
        print_success "No LaTeX warnings"
    fi
    
    echo ""
    
    if [ "$TOTAL_BOXES" -gt 0 ]; then
        print_warning "Box warnings (layout issues): $TOTAL_BOXES"
        echo "  - Overfull boxes: $OVERFULL"
        echo "  - Underfull boxes: $UNDERFULL"
        echo ""
        echo "  (These are usually minor formatting issues)"
    else
        print_success "No box warnings"
    fi
    
    # Check for missing packages
    MISSING_PACKAGES=$(grep "File .* not found" "$LOG_FILE" 2>/dev/null || true)
    if [ -n "$MISSING_PACKAGES" ]; then
        echo ""
        print_error "Missing packages detected:"
        echo "$MISSING_PACKAGES"
    fi
    
    # Check for font warnings
    FONT_WARNINGS=$(grep -c "Font Warning" "$LOG_FILE" 2>/dev/null || echo "0")
    if [ "$FONT_WARNINGS" -gt 0 ]; then
        echo ""
        print_warning "Font warnings: $FONT_WARNINGS"
    fi
fi

echo ""
echo -e "${BLUE}--- End of Summary ---${NC}"
echo ""

# Final status
if [ "${COMPILE_FAILED:-0}" -eq 0 ]; then
    print_success "Validation complete: $TEX_FILE is valid!"
    echo ""
    echo "To generate PDF, run:"
    echo "  pdflatex $TEX_FILE"
    exit 0
else
    exit 1
fi
