#!/usr/bin/env bash
#===============================================================================
# build-tectonic.sh — Safe Tectonic build wrapper with temporary symlinks
#
# This script allows building LaTeX documents with Tectonic while keeping
# shared class/style files (e.g., awesome-cv.cls, fontawesome.sty) outside
# the source tree. It temporarily symlinks everything from
#   $DEVENV_ROOT/lib/zzamboni/
# into
#   $DEVENV_ROOT/src/
# so Tectonic can find them in workspace mode.
#
# Usage:
#   ./build-tectonic.sh                → Build all documents via
#                                        `tectonic -X build`
#   ./build-tectonic.sh src/foo.tex    → Build a specific .tex file into
#                                        $DEVENV_ROOT/build/foo/
#
# The script always removes the created symlinks, even if the build fails.
#===============================================================================

set -euo pipefail

#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------
DEVENV_ROOT="${DEVENV_ROOT:-$(pwd)}"
LIB_DIR="$DEVENV_ROOT/lib/zzamboni"
SRC_DIR="$DEVENV_ROOT/src"

# Keep track of created symlinks
links=()

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

create_symlinks() {
    for f in "$LIB_DIR"/*; do
        base=$(basename "$f")
        target="$SRC_DIR/$base"
        ln -s "$(realpath --relative-to="$SRC_DIR" "$f")" "$target"
        links+=("$target")
    done
}

remove_symlinks() {
    for l in "${links[@]}"; do
        rm -f "$l"
    done
}

# Always clean up on exit
trap remove_symlinks EXIT

#------------------------------------------------------------------------------
# Main logic
#------------------------------------------------------------------------------
create_symlinks

if [ $# -eq 0 ]; then
    echo "→ Building all documents with Tectonic (workspace mode)..."
    tectonic -X build
else
    input="$1"
    base=$(basename "$input" .tex)
    output_dir="$DEVENV_ROOT/build/$base"
    mkdir -p "$output_dir"
    echo "→ Building specific file: $input"
    tectonic "$input" -o "$output_dir"
fi

