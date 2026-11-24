set shell := ["bash", "-euo", "pipefail", "-c"]

openscad := env("OPENSCAD", "openscad")

# List the recipes
default:
    @just --list

# Check formatting, then evaluate every example and the docs' code, failing on a warning
check: fmt-check examples docs-check

# Evaluate every example and fail on the first warning
examples:
    @for f in examples/*/*.scad; do \
        echo "$f"; \
        status=0; out=$({{ openscad }} --hardwarnings --export-format csg -o /dev/null "$f" 2>&1) || status=$?; \
        if ((status)) || grep -Eq '^(WARNING|ERROR)' <<<"$out"; then echo "$out"; exit 1; fi; \
    done

# Evaluate the scad blocks in README.md and docs/, and check scripts/images.tsv
docs-check:
    @OPENSCAD={{ openscad }} python3 -I scripts/docs.py check

# Draw the docs pictures listed in scripts/images.tsv, or only those matching the names or globs given
images *names:
    @OPENSCAD={{ openscad }} python3 -I scripts/docs.py images {{ names }}

# Run the fixtures in tests/ and check what each one produces
test:
    @OPENSCAD={{ openscad }} bash tests/run.sh

# Format the .scad sources with topiary (.topiary/languages.ncl)
fmt:
    git ls-files -z '*.scad' | xargs -0 -r topiary format

# Check the .scad sources are formatted, without changing them
fmt-check:
    git ls-files -z '*.scad' | xargs -0 -r -n1 topiary format --check
