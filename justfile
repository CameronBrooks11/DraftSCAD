set shell := ["bash", "-euo", "pipefail", "-c"]

openscad := env("OPENSCAD", "openscad")

# List the recipes
default:
    @just --list

# Check formatting, then evaluate every example and fail on the first warning
check: fmt-check
    @for f in examples/*/*.scad; do \
        echo "$f"; \
        if {{ openscad }} --hardwarnings --export-format csg -o /dev/null "$f" 2>&1 | grep -E '^(WARNING|ERROR)'; then exit 1; fi; \
    done

# Run the fixtures in tests/ and check what each one produces
test:
    @OPENSCAD={{ openscad }} bash tests/run.sh

# Format the .scad sources with topiary (.topiary/languages.ncl)
fmt:
    git ls-files -z '*.scad' | xargs -0 -r topiary format

# Check the .scad sources are formatted, without changing them
fmt-check:
    git ls-files -z '*.scad' | xargs -0 -r -n1 topiary format --check
