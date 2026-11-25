# Contributing to DraftSCAD

Bug fixes, new features and documentation improvements are welcome. The
[open issues](https://github.com/CameronBrooks11/DraftSCAD/issues) list the work that is planned; for an idea that is
not there, open an issue first. Work on a branch, and open a pull request against `main`.

## What you need

- OpenSCAD 2026.10.15, the snapshot CI runs: `OpenSCAD-2026.10.15-x86_64.AppImage` from
  <https://files.openscad.org/snapshots/>, as the "Install OpenSCAD" step in `.github/workflows/test.yml` does. The
  2021.01 build that Debian and Ubuntu ship is not enough on its own: on it the checks evaluate files without building
  their geometry, and skip the fixtures that need a newer OpenSCAD, so a change can pass locally and fail in CI. CI
  also runs the checks on 2021.01, in a separate job.
- [topiary](https://github.com/tweag/topiary/releases/tag/v0.8.0) 0.8.0, which formats the `.scad` sources; CI runs
  `topiary prefetch openscad` once after installing it.
- [just](https://github.com/casey/just), which runs the recipes below.
- Python 3, for the docs check.

`OPENSCAD=/path/to/openscad just test` runs the recipes against another OpenSCAD.

## Before a pull request

Run `just check` and `just test`. CI runs the same two. The formatting recipes work on the files git tracks, so
`git add` a new `.scad` file before running them, or `just check` passes on a file CI will reject.

| Recipe            | Does                                                                                         |
| ----------------- | -------------------------------------------------------------------------------------------- |
| `just check`      | `fmt-check`, then `examples`, then `docs-check`                                              |
| `just fmt`        | Formats the `.scad` sources; `just fmt-check` only checks them                               |
| `just examples`   | Checks every file under `examples/`                                                          |
| `just docs-check` | Checks the `scad` blocks in the README and `docs/`, and `scripts/images.tsv` (see below)     |
| `just test`       | Runs the fixtures in `tests/`, then the tests of `scad-check.sh` and of the docs check       |
| `just images`     | Redraws the pictures in `docs/assets/images` from `scripts/images.tsv`                       |

Every example, docs block and fixture is checked by [scripts/scad-check.sh](scripts/scad-check.sh), and the library
files with them, as they include it. It fails on any warning or error line, including `DEPRECATED` and prefixed ones
such as `FONT-WARNING`. Where OpenSCAD's `--help` lists `--backend`, it also builds the geometry on the Manifold
backend, where a missing `import()` file or 2D mixed with 3D shows up. On 2021.x, which has only CGAL, it evaluates
the file only. Any other OpenSCAD whose `--help` does not list `--backend` fails, so the geometry is never skipped
unseen.

## Fixtures

A fixture is a `.scad` file in `tests/`. It fails when `scad-check.sh` reports a problem, or when one of these lines
in it does not hold. Write them exactly as shown, at the start of a line; a misspelt one is ignored. The output
searched is the CSG export plus the console messages.

| Line                       | Means                                                                                  |
| -------------------------- | -------------------------------------------------------------------------------------- |
| `// expect: REGEX`         | Something in the output matches                                                        |
| `// reject: REGEX`         | Nothing in the output matches                                                          |
| `// expect-error: REGEX`   | The file must fail `scad-check.sh`, with every such regex in what it reported          |
| `// min-openscad: VERSION` | Skipped, and reported as skipped, on an older OpenSCAD                                 |

`expect-error` is for testing an assert. Keep one failing assert to a fixture: OpenSCAD stops at the first, so a
second is never reached.

Before relying on a new fixture, break the thing it guards and watch it fail.

## Docs

The docs site is built from `docs/` by the docs engine; CI's "Docs site" job builds it and checks its links on every
pull request. `just docs-check` evaluates each block written as a top-level fence opened by ` ```scad `, with nothing
but spaces after it, and closed by ` ``` `. It reports any other line that looks like an OpenSCAD fence, such as one in
a list or a quote, or written as ` ```openscad `. A page's blocks that start with `// file: NAME` are written beside
each other, so one block can include another, and each of them is evaluated. Any other block with no `include` or
`use`, such as a module's signature, is not.

`scripts/images.tsv` lists each picture in `docs/assets/images` with its source and camera, and `just docs-check`
fails on a picture without a row: add the row for a new picture, then run `just images`. A page picture is drawn from
the `scad` block just before it on its page, which must include the library and draw something. If a change alters a
drawing the docs show, run `just images`, look at the pictures, and commit the ones that changed.

## Changelog and commits

If a change is one a user of the library would notice, add a line under Unreleased in [CHANGELOG.md](CHANGELOG.md),
saying what changed since the last release.

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/): a type (`feat`, `fix`, `docs`,
`test`, `ci`, `build`, `refactor`, `chore`), an optional scope, and a subject, as in `fix(docs): ...` or
`feat(dimensions): ...`.
