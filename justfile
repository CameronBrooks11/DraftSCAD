set shell := ["bash", "-euo", "pipefail", "-c"]

openscad := env("OPENSCAD", "openscad")

# List the recipes
default:
    @just --list

# Evaluate every example with OpenSCAD and fail on the first warning
check:
    @for f in examples/*/*.scad; do \
        echo "$f"; \
        {{ openscad }} --hardwarnings --export-format csg -o - "$f" > /dev/null; \
    done
