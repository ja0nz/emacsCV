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

    # Make input absolute relative to DEVENV_ROOT
    local abs_input
    if [[ "$input" = /* ]]; then
        abs_input="$input"           # already absolute
    else
        abs_input="$(pwd)/$input"
    fi

    # --- create temporary directory for patched class ---
    TMPDIR=$(mktemp -d)
    trap 'rm -rf "$TMPDIR"' EXIT

    # concatenate upstream + overrides into temp class
    cat "$UPSTREAM_CLS" "$OVERRIDES_CLS" > "$TMPDIR/awesome-cv.cls"

    # prepend temp directory to TEXINPUTS
    export TEXINPUTS="$TMPDIR${TEXINPUTS:+:$TEXINPUTS}:"

    # --- build from root so .latexmkrc is found ---
    pushd "$DEVENV_ROOT" > /dev/null
    latexmk -xelatex "$abs_input" || true
    latexmk -c "$abs_input"
    popd > /dev/null

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
