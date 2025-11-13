#!/usr/bin/env bash
#===============================================================================
# build-latexmk.sh — Minimal wrapper for latexmk
#
# Compiles one .tex file or all .tex files in $DEVENV_ROOT/src using XeLaTeX.
# Cleans auxiliary files afterward.
#===============================================================================

set -euo pipefail

DEVENV_ROOT="${DEVENV_ROOT:-$(pwd)}"
SRC_DIR="$DEVENV_ROOT/src"

build_tex() {
    local input="$1"
    latexmk -xelatex "$input" || true
    latexmk -c "$input"
}

if [ $# -eq 0 ]; then
    for tex in "$SRC_DIR"/*.tex; do
        [ -e "$tex" ] || continue
        build_tex "$tex"
    done
else
    build_tex "$1"
fi

