# Contributing to DraftSCAD

Bug fixes, new features and documentation improvements are welcome. The
[open issues](https://github.com/CameronBrooks11/DraftSCAD/issues) list the work that is planned; for an idea that is
not there, open an issue first.

## What you need

- OpenSCAD. CI runs the 2026.10.15 snapshot, and also checks the examples, the docs' code and the fixtures on 2021.01,
  the build Debian and Ubuntu ship.
- [topiary](https://github.com/tweag/topiary) 0.8.0, which formats the `.scad` sources.
- [just](https://github.com/casey/just), which runs the recipes below.
- Python 3, for the docs check.

`OPENSCAD=/path/to/openscad just test` runs the recipes against another OpenSCAD.

## Before a pull request

Run `just check` and `just test`. CI runs the same two.

| Recipe            | Does                                                                                         |
| ----------------- | -------------------------------------------------------------------------------------------- |
| `just check`      | `fmt-check`, then `examples`, then `docs-check`                                              |
| `just fmt`        | Formats the `.scad` sources; `just fmt-check` only checks them                               |
| `just examples`   | Checks every file under `examples/`                                                          |
| `just docs-check` | Checks every `scad` block in the README and `docs/` that includes or uses a file             |
| `just test`       | Runs the fixtures in `tests/`, then the tests of `scad-check.sh` and of the docs check       |
| `just images`     | Redraws the pictures in `docs/assets/images` from `scripts/images.tsv`                       |

Every OpenSCAD file is checked by [scripts/scad-check.sh](scripts/scad-check.sh). It fails on any warning or error
line, including `DEPRECATED` and prefixed ones such as `FONT-WARNING`. Where OpenSCAD's `--help` lists `--backend`, it
also builds the geometry on the Manifold backend, where a missing `import()` file or 2D mixed with 3D shows up. On
2021.x, which has only CGAL, it evaluates the file only. Any other OpenSCAD whose `--help` does not list `--backend`
fails, so the geometry is never skipped unseen.

## Fixtures

A fixture is a `.scad` file in `tests/`. It fails when `scad-check.sh` reports a problem, or when one of these lines
in it does not hold. The output searched is the CSG export plus the console messages.

| Line                       | Means                                                                                  |
| -------------------------- | -------------------------------------------------------------------------------------- |
| `// expect: REGEX`         | Something in the output matches                                                        |
| `// reject: REGEX`         | Nothing in the output matches                                                          |
| `// expect-error: REGEX`   | The file must fail `scad-check.sh`, with the regex in what it reported: an assert test |
| `// min-openscad: VERSION` | Skipped, and reported as skipped, on an older OpenSCAD                                 |

Keep one `expect-error` call to a fixture: OpenSCAD stops at the first failed assert, so a second is never reached.

Before relying on a new fixture, break the thing it guards and watch it fail.

## Docs

The docs site is built from `docs/` by the docs engine. `just docs-check` evaluates each block written as a
top-level fence opened by exactly ` ```scad ` and closed by ` ``` `, and reports any other line that looks like an
OpenSCAD fence, such as one in a list or a quote, or written as ` ```openscad `. A page's blocks that start with
`// file: NAME` are written beside each other, so one block can include another. A block with no `include` or `use`,
such as a module's signature, is not evaluated.

If a change alters a drawing the docs show, run `just images`, look at the pictures, and commit the ones that changed.
A page picture is drawn from the `scad` block just before it on its page; `scripts/images.tsv` lists each picture
with its source and camera.

## Changelog and commits

If a change is one a user of the library would notice, add a line under Unreleased in [CHANGELOG.md](CHANGELOG.md),
saying what changed since the last release.

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/): `fix(templates): ...`,
`docs: ...`, `test: ...`.
