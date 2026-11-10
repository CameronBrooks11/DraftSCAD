#!/usr/bin/env bash
# Evaluates every fixture in this directory with OpenSCAD and checks what it produces.
#
# A fixture fails when OpenSCAD reports a warning or error, when a line
#   // expect: REGEX
# in the fixture matches nothing in the output, or when a line
#   // reject: REGEX
# matches something. The output searched is the CSG export plus the console messages.
set -euo pipefail

openscad=${OPENSCAD:-openscad}
dir=$(cd "$(dirname "$0")" && pwd)
failed=0

for fixture in "$dir"/*.scad; do
    name=$(basename "$fixture")
    problems=()

    if ! out=$("$openscad" --hardwarnings --export-format csg -o - "$fixture" 2>&1); then
        problems+=("OpenSCAD exited with a warning or error")
    fi

    while IFS= read -r pattern; do
        grep -Eq -- "$pattern" <<<"$out" || problems+=("expected but not found: $pattern")
    done < <(sed -n 's|^// expect: ||p' "$fixture")

    while IFS= read -r pattern; do
        ! grep -Eq -- "$pattern" <<<"$out" || problems+=("found but rejected: $pattern")
    done < <(sed -n 's|^// reject: ||p' "$fixture")

    if ((${#problems[@]})); then
        failed=$((failed + 1))
        echo "FAIL $name"
        printf '     %s\n' "${problems[@]}"
        grep -E 'WARNING|ERROR' <<<"$out" | sed 's/^/     /' || true
    else
        echo "ok   $name"
    fi
done

if ((failed)); then
    echo "$failed fixture(s) failed"
    exit 1
fi
