#!/usr/bin/env bash
#===============================================================================
# build-latexmk.sh — Minimal wrapper for latexmk
#
# Compiles one .tex file or all .tex files in $DEVENV_ROOT/src using XeLaTeX.
# Cleans auxiliary files afterward.
# Injects a temporary patched awesome-cv.cls at build time.
#===============================================================================

set -euo pipefail

DEVENV_ROOT="${DEVENV_ROOT:-$(pwd)}"
SRC_DIR="$DEVENV_ROOT/src"
UPSTREAM_CLS="$DEVENV_ROOT/lib/Awesome-CV/awesome-cv.cls"
OVERRIDES_CLS="$DEVENV_ROOT/lib/awesome-cv-additions.cls"

build_tex() {
    local input="$1"

    # --- create temporary directory for patched class ---
    TMPDIR=$(mktemp -d)
    trap 'rm -rf "$TMPDIR"' EXIT

    # concatenate upstream + overrides into temp class
    cat "$UPSTREAM_CLS" "$OVERRIDES_CLS" > "$TMPDIR/awesome-cv.cls"

    # prepend temp directory to TEXINPUTS
    export TEXINPUTS="$TMPDIR${TEXINPUTS:+:$TEXINPUTS}:"

    # compile
    latexmk -xelatex "$input" || true
    latexmk -c "$input"

    # cleanup happens automatically via trap
}

if [ $# -eq 0 ]; then
    for tex in "$SRC_DIR"/*.tex; do
        [ -e "$tex" ] || continue
        build_tex "$tex"
    done
else
    build_tex "$1"
fi
