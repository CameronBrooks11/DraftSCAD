#!/usr/bin/env bash
# Checks one .scad file: prints what OpenSCAD reported, and exits 1 on any warning or error.
#
#   scad-check.sh FILE
#
# It evaluates the file with a CSG export. Where OpenSCAD has the Manifold backend it also builds
# the geometry, as an STL export or an SVG one for a 2D file. Some warnings only appear there, such
# as an import() of a missing file, or 2D mixed with 3D. OpenSCAD 2021.01 has only CGAL, which takes
# minutes on extruded text, so on it the file is evaluated only.
#
# A warning is a line starting with WARNING, ERROR, DEPRECATED, or a word joined to -WARNING or
# -ERROR, such as FONT-WARNING. The exit status alone is not enough: 2021.01 exits 0 on some
# warnings, and every version exits 0 on a failed assert. A file that draws nothing is fine.
set -uo pipefail

openscad=${OPENSCAD:-openscad}
file=${1:?usage: scad-check.sh FILE}
warning='^([A-Z]+-)?(WARNING|ERROR)|^DEPRECATED'

# Runs OpenSCAD; prints the warnings, or the output when it failed without one. Sets $out.
run() {
    local status=0
    out=$("$openscad" --hardwarnings "$@" 2>&1) || status=$?
    if grep -Eq "$warning" <<<"$out"; then
        grep -E "$warning" <<<"$out"
        return 1
    fi
    if ((status)) && ! grep -Eq 'Current top level object is (empty|not a 3D object)' <<<"$out"; then
        echo "$openscad exited $status"
        grep -v '^[[:space:]]*$' <<<"$out" | head -n 8
        return 1
    fi
}

run --export-format csg -o /dev/null "$file" || exit 1

help=$("$openscad" --help 2>&1) || true
if [[ $help == *--backend* ]]; then
    run --backend=manifold --export-format binstl -o /dev/null "$file" || exit 1
    if grep -q 'Current top level object is not a 3D object' <<<"$out"; then
        run --backend=manifold --export-format svg -o /dev/null "$file" || exit 1
    fi
fi
