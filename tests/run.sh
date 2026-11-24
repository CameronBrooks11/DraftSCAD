#!/usr/bin/env bash
# Evaluates every fixture in this directory with OpenSCAD and checks what it produces.
#
# A fixture fails when OpenSCAD reports a warning or error, when a line
#   // expect: REGEX
# in the fixture matches nothing in the output, or when a line
#   // reject: REGEX
# matches something. The output searched is the CSG export plus the console messages.
#
# A fixture with a line
#   // min-openscad: VERSION
# is skipped, and reported as skipped, on an older OpenSCAD.
set -euo pipefail

openscad=${OPENSCAD:-openscad}
dir=$(cd "$(dirname "$0")" && pwd)
failed=0
skipped=0

version=$("$openscad" --version 2>&1 | sed -n 's/^OpenSCAD version //p') || true
if [[ -z $version ]]; then
    echo "could not read the version from $openscad --version"
    exit 1
fi

for fixture in "$dir"/*.scad; do
    name=$(basename "$fixture")
    problems=()

    min=$(sed -n 's|^// min-openscad:||p' "$fixture")
    if [[ -n $min && ! $min =~ ^\ [0-9]+(\.[0-9]+)*$ ]]; then
        failed=$((failed + 1))
        echo "FAIL $name"
        echo "     min-openscad must be one version, such as 2026.10.15: '$min'"
        continue
    fi
    min=${min# }
    if [[ -n $min && $(printf '%s\n' "$min" "$version" | sort -V | head -n1) != "$min" ]]; then
        skipped=$((skipped + 1))
        echo "skip $name (needs OpenSCAD $min, have $version)"
        continue
    fi

    # A failed assert still exits 0, so the output is read as well as the exit status.
    status=0
    out=$("$openscad" --hardwarnings --export-format csg -o - "$fixture" 2>&1) || status=$?
    if ((status)) || grep -Eq '^(WARNING|ERROR)' <<<"$out"; then
        problems+=("OpenSCAD reported a warning or error")
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

if ((skipped)); then
    echo "$skipped fixture(s) skipped"
fi
if ((failed)); then
    echo "$failed fixture(s) failed"
    exit 1
fi
