#!/usr/bin/env bash
# Checks one .scad file: prints what OpenSCAD reported, and exits 1 on any warning or error.
#
#   scad-check.sh FILE
#
# It evaluates the file with a CSG export, then builds its geometry with an STL export, on the
# Manifold backend. Some warnings only appear there, such as an import() of a missing file, or 2D
# mixed with 3D; a 2D file's geometry is built before the STL export turns it down. OpenSCAD
# 2021.x has only CGAL, which takes minutes on extruded text, so on any 2021.x the file is evaluated
# only. Any other version whose --help does not list --backend fails, rather than skip the build
# unseen. tests/scad-check.test.sh tests this script against a fake OpenSCAD.
#
# A warning is a line starting with WARNING, ERROR, DEPRECATED, or a word joined to -WARNING or
# -ERROR, such as FONT-WARNING; the TRACE lines after it say where it came from. The exit status
# alone is not enough: 2021.01 exits 0 on some warnings, and every version exits 0 on a failed
# assert. A file that draws nothing, or draws only 2D, passes.
set -uo pipefail

openscad=${OPENSCAD:-openscad}
file=${1:?usage: scad-check.sh FILE}
warning='^([A-Z]+-)?(WARNING|ERROR)|^DEPRECATED'

# Runs OpenSCAD and prints the warnings with their TRACE lines, or the output when it failed without
# one. Exit status 1 is allowed when the output has a line matching $1; any other failure, such as a
# crash, is not.
run() {
    local allowed=$1 status=0 out
    shift
    out=$("$openscad" --hardwarnings "$@" 2>&1) || status=$?
    if grep -Eq "$warning" <<<"$out"; then
        grep -E "$warning|^TRACE:" <<<"$out"
        return 1
    fi
    if ((status)) && ! { ((status == 1)) && [[ -n $allowed ]] && grep -Eq "$allowed" <<<"$out"; }; then
        echo "$openscad exited $status"
        grep -v '^[[:space:]]*$' <<<"$out" | head -n 8
        return 1
    fi
}

run "" --export-format csg -o /dev/null "$file" || exit 1

version=$("$openscad" --version 2>&1 | sed -n 's/^OpenSCAD version //p') || true
if [[ $version == 2021.* ]]; then
    exit 0
fi
help=$("$openscad" --help 2>&1) || true
if [[ $help != *--backend* ]]; then
    echo "OpenSCAD ${version:-of unknown version} has no --backend, so the geometry cannot be built"
    exit 1
fi
run $'^Current top level object is (empty|not a 3D object)\\.\r?$' \
    --backend=manifold --export-format binstl -o /dev/null "$file" || exit 1
