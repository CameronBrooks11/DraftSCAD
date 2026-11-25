set shell := ["bash", "-euo", "pipefail", "-c"]

openscad := env("OPENSCAD", "openscad")

# List the recipes
default:
    @just --list

# Check formatting, then evaluate every example and the docs' code, failing on a warning
check: fmt-check examples docs-check

# Check every example with scripts/scad-check.sh and fail on the first warning
examples:
    @for f in examples/*/*.scad; do \
        echo "$f"; \
        OPENSCAD={{ openscad }} bash scripts/scad-check.sh "$f"; \
    done

# Evaluate the scad blocks in README.md and docs/, and check scripts/images.tsv
docs-check:
    @OPENSCAD={{ openscad }} python3 -I scripts/docs.py check

# Draw the docs pictures listed in scripts/images.tsv, or only those matching the names or globs given
[positional-arguments]
images *names:
    @OPENSCAD={{ openscad }} python3 -I scripts/docs.py images "$@"

# Run the fixtures in tests/ and check what each one produces, then test scad-check.sh and docs.py
test:
    @OPENSCAD={{ openscad }} bash tests/run.sh
    @bash tests/scad-check.test.sh
    @python3 -I -B tests/docs-scan.test.py

# Format the .scad sources with topiary (.topiary/languages.ncl)
fmt:
    git ls-files -z '*.scad' | xargs -0 -r topiary format

# Check the .scad sources are formatted, without changing them
fmt-check:
    git ls-files -z '*.scad' | xargs -0 -r -n1 topiary format --check
