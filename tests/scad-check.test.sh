#!/usr/bin/env bash
# Tests scripts/scad-check.sh against a fake OpenSCAD, for the cases a real build does not produce
# on demand: a crash, CRLF output, a missing --backend, warnings of every prefix.
#
# Each case sets what the fake prints and its exit status for the CSG run and the STL run, and its
# version and --help text, then checks the exit status of scad-check.sh. It needs no OpenSCAD.
set -euo pipefail

dir=$(cd "$(dirname "$0")" && pwd)
check="$dir/../scripts/scad-check.sh"
tmp=$(mktemp -d)
[[ -n $tmp && -d $tmp ]] || exit 1
trap 'rm -rf -- "$tmp"' EXIT

# The fake reads its behaviour from FAKE_* variables; printf %b turns \n and \r into the bytes.
fake="$tmp/openscad"
cat >"$fake" <<'FAKE'
#!/usr/bin/env bash
echo "$*" >>"$FAKE_LOG"
case "$*" in
    *--version*) printf '%b' "OpenSCAD version $FAKE_VERSION\n" >&2; exit 0 ;;
    *--help*) printf '%b' "$FAKE_HELP" >&2; exit 0 ;;
    *--export-format\ csg*) printf '%b' "$FAKE_CSG_OUT" >&2; exit "$FAKE_CSG_EXIT" ;;
    *--export-format\ binstl*) printf '%b' "$FAKE_STL_OUT" >&2; exit "$FAKE_STL_EXIT" ;;
esac
exit 0
FAKE
chmod +x "$fake"
touch "$tmp/x.scad"

failed=0
empty='Current top level object is empty.'
not3d='Current top level object is not a 3D object.'

# case NAME WANT [VAR=VALUE ...]: WANT is the exit status scad-check.sh must give.
case_() {
    local name=$1 want=$2 got=0
    shift 2
    : >"$tmp/log"
    env FAKE_LOG="$tmp/log" FAKE_VERSION=2026.10.15 FAKE_HELP='  --backend arg\n' \
        FAKE_CSG_OUT='' FAKE_CSG_EXIT=0 FAKE_STL_OUT='' FAKE_STL_EXIT=0 "$@" \
        OPENSCAD="$fake" bash "$check" "$tmp/x.scad" >"$tmp/out" 2>&1 || got=$?
    if ((got == want)); then
        echo "ok   $name"
    else
        failed=$((failed + 1))
        echo "FAIL $name: exit $got, want $want"
        sed 's/^/     /' "$tmp/out"
    fi
}

case_ "a clean file passes" 0
case_ "a file that draws nothing passes" 0 FAKE_STL_OUT="$empty\n" FAKE_STL_EXIT=1
case_ "a 2D file passes" 0 FAKE_STL_OUT="$not3d\n" FAKE_STL_EXIT=1
case_ "CRLF output from an empty file passes" 0 FAKE_STL_OUT="$empty\r\n" FAKE_STL_EXIT=1
case_ "CRLF output from a 2D file passes" 0 FAKE_STL_OUT="$not3d\r\n" FAKE_STL_EXIT=1
case_ "a crash that prints the empty line fails" 1 FAKE_STL_OUT="Segmentation fault\n$empty\n" FAKE_STL_EXIT=139
case_ "exit 2 with the empty line fails" 1 FAKE_STL_OUT="$empty\n" FAKE_STL_EXIT=2
case_ "the empty line with text after it fails" 1 FAKE_STL_OUT="$empty more\n" FAKE_STL_EXIT=1
case_ "the empty line with text after a CR fails" 1 FAKE_STL_OUT="$empty\rmore\n" FAKE_STL_EXIT=1
case_ "the empty line inside an ECHO fails" 1 FAKE_STL_OUT="ECHO: \"$empty\"\n" FAKE_STL_EXIT=1
case_ "the empty line after other text fails" 1 FAKE_STL_OUT="crashed: $empty\n" FAKE_STL_EXIT=1
case_ "the empty line excuses nothing in the CSG run" 1 FAKE_CSG_OUT="$empty\n" FAKE_CSG_EXIT=1
case_ "a plain crash fails" 1 FAKE_STL_OUT="Segmentation fault\n" FAKE_STL_EXIT=139
case_ "a WARNING fails, exit 0 or not" 1 FAKE_CSG_OUT="WARNING: x\n"
case_ "an ERROR fails" 1 FAKE_CSG_OUT="ERROR: x\n"
case_ "a DEPRECATED line fails" 1 FAKE_CSG_OUT="DEPRECATED: x\n"
case_ "a FONT-WARNING fails" 1 FAKE_STL_OUT="FONT-WARNING: x\n"
case_ "an EXPORT-ERROR fails" 1 FAKE_STL_OUT="EXPORT-ERROR: x\n"
case_ "an ECHO mentioning WARNING passes" 0 FAKE_CSG_OUT="ECHO: \"WARNING\"\n"
case_ "a snapshot without --backend fails" 1 FAKE_HELP='Usage: openscad\n'
case_ "an unknown version without --backend fails" 1 FAKE_VERSION='' FAKE_HELP='Usage: openscad\n'

# 2021.x evaluates only: a geometry warning would fail, so passing shows the STL run was skipped.
case_ "2021.01 evaluates only" 0 FAKE_VERSION=2021.01 FAKE_HELP='Usage: openscad\n' FAKE_STL_OUT="WARNING: x\n"
if grep -q binstl "$tmp/log"; then
    failed=$((failed + 1))
    echo "FAIL 2021.01 evaluates only: the STL run happened"
fi

if ((failed)); then
    echo "$failed scad-check case(s) failed"
    exit 1
fi
