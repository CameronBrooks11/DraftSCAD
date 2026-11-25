# Changelog

All notable changes to DraftSCAD are recorded here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.2.1] - 2026-11-25

### Changed

- `titleblock0()`, `revblock0()` and `titleblock1()` take `fill` as `true` or `false` only. Any other value, such as
  the string `"true"` the reference used to show for `titleblock0()`, or `0` and `1`, which worked before, now stops
  with an `assert` (#58).

### Fixed

- `titleblock0()` took `fill` as the string `"true"` by default, so `fill = "false"`, as its documented signature
  suggested, still drew the white slab, as it did in `revblock0()` and `titleblock1()`. `fill` defaults to `true` in
  every template (#58).

## [0.2.0] - 2026-11-25

### Added

- `dimensions(text = ...)`, a custom label in place of `str(length)`, for a prefix, units, a tolerance or a set
  precision. A number is drawn as `str()` writes it, up to 6 significant figures without trailing zeros, so a set
  number of decimals needs a string; any value but a string, a finite number or `undef` stops with an `assert`
  naming the parameter (#26, #43, #50).
- The `TEXT_SIZE` override, read as `DIM_TEXT_SIZE`. It sets the height of dimension and leader labels without
  changing the line width. The default is unchanged at 7 line widths (#2).
- `dd_text_units()`, which estimates the width of a label: each printable ASCII character counts its advance in the
  default font. It is exact for most ASCII labels; a pair the font kerns, such as `11` or `AV`, comes out slightly
  wide (#2, #26).
- `just fmt` and `just fmt-check`, which format the `.scad` sources with topiary, in place of `.clang-format`;
  `just check` runs `fmt-check` first (#31).
- `just docs-check`, part of `just check`, which evaluates every `scad` block in the README and `docs/` that includes
  or uses a file, checks `scripts/images.tsv`, and reports an OpenSCAD fence it cannot read, such as one in a list, a
  quote or under another spelling (#28, #38, #46).
- `just images`, which redraws the pictures in `docs/assets/images` from `scripts/images.tsv` (#28).
- `scripts/scad-check.sh`, through which `just check` and `just test` check each file: on OpenSCAD's Manifold backend
  it also builds the geometry, where a missing `import()` file or 2D mixed with 3D shows up, and it fails on
  `DEPRECATED` and prefixed warnings such as `FONT-WARNING` too (#36, #44).
- Fixture markers: `// min-openscad: VERSION` skips a fixture on an older OpenSCAD (#33), and
  `// expect-error: REGEX` makes it a test of an assert (#50).
- Tests of the tooling itself: `scad-check.sh` against a fake OpenSCAD, and how `docs-check` reads the docs' fences
  (#46, #49, #53).

### Changed

- `dimensions()` centres its label in the break in the line, and sizes the break from the label's estimated width.
  Labels sit slightly differently from 0.1.0 (#2).
- `dimensions()` with `DIM_LEFT` and `DIM_RIGHT` puts the label the same short distance from its arrow on either
  side. The right-hand label used to sit a full label width away (#2).
- `dimensions()` with `DIM_OUTSIDE` puts the label past the right-hand arrow when it does not fit between the arrows,
  where it used to be drawn across them (#2).
- A left-hand `leader_line()` label is right-aligned against its shoulder line (#2).
- The circle drawn by `leader_line(do_circle = true)` is sized from the label, so its edge meets the end of the
  shoulder line. For digits and most labels it is smaller than in 0.1.0; for a single capital letter it is usually
  larger (#2, #26).
- CI's required `test` job runs on a pinned OpenSCAD 2026.10.15 snapshot and checks formatting. OpenSCAD 2021.01,
  which CI ran in 0.1.0, now runs in a separate `compat-2021` job that is not required (#31, #33).
- The documentation site is built with the docs engine; the Jekyll setup in `docs/` is gone. The site's address is
  unchanged (#29, #30).

### Fixed

- Dimension labels overlapped arrows and the dimension line, most visibly at a large `SCALING_FACTOR` (#2).
- `dimensions()` with `DIM_CENTER` produced negative-size geometry when the label did not fit, and so did a short
  `DIM_OUTSIDE`, whose arrows had shafts of negative length. A `DIM_CENTER` that does not fit now draws the
  outside-arrows form, and outside arrows are at least two arrowheads long (#2).
- The labels of `dimensions()`, `leader_line()` and `titleblock()` were 2D beside 3D lines, so a render (F6) or an
  STL export dropped them with a warning. They are now extruded to the height of the lines, and look the same from
  above. On OpenSCAD 2021.01, rendering a drawing with many labels can take minutes (#39).
- `leader_line(text = ...)` given a number, such as a balloon's `text = 1`, warned and drew no label. It now draws the
  number as `str()` writes it. An explicit `text = undef`, which also warned, draws the line alone, and any value but
  a string, a finite number or `undef` stops with an `assert` where it used to warn or draw nothing (#43, #50).
- `just check` and `just test` passed an example or fixture whose `assert` failed, on OpenSCAD 2026.10.15 and
  2021.01, and on 2021.01 they passed some warnings, such as an unknown variable (#31, #34).

## [0.1.0] - 2026-11-10

The first tagged version. It includes everything in "History before this changelog" below.

### Added

- `just check`, which evaluates every example with OpenSCAD and fails on any warning (#7).
- Documentation for the current library: getting started, workflow, configuration, a reference for every module,
  and the examples (#15).
- A documentation site at <https://cameronbrooks11.github.io/DraftSCAD/>, built from `docs/` (#16).
- A `.gitignore` for OpenSCAD exports and editor directories, and a CI run of `just check` on every pull request
  (#17).
- This changelog (#14).
- `just test`, which runs the fixtures in `tests/` and checks what each one produces (#19).

### Changed

- The task list moved from `docs/TODO.md` to the issue tracker (#8).
- The example images moved from `images/` to `docs/assets/images/` (#15).

### Removed

- The legacy write-up in `docs/README.md` and its sample images (#15).

### Fixed

- `mypart()` in the Don Smiley example ignored its `radius` parameter (#13).
- `leader_line()` produced warnings when called without `text`. The label is now optional (#12).
- `draw_sheet()` with `grid_type = "Grid"` passed the grid colour as the line height and warned on every grid line (#10).
- `draw_sheet(sheet_symbol = ...)` found the sheet size and then drew nothing (#9).
- The circle drawn by `leader_line(do_circle = true)` was a solid disc at a large `SCALING_FACTOR`, and was missing
  with `direction = DIM_LEFT` (#11).

## History before this changelog

Rebuilt from the commit log. These changes predate the first tag and are all part of 0.1.0.

### 2025-01-15

- Added the `vert` parameter to `line()`.
- Added the `LINE_COLOR` and `TEXT_COLOR` overrides, read as `DEF_LINE_COLOR` and `DEF_TEXT_COLOR`.
- Added a `line_height` parameter to `circle_center()`, `dimensions()`, `leader_line()`, `draw_sheet()` and
  `draw_frame()`.
- Renamed `DIM_HEIGHT` to `DIM_LINE_HEIGHT`.
- Renamed the `horz_line_length` parameter of `leader_line()` to `horz_length`.

### 2024-12-20

- Added `draw_grid()` and the `grid_type` option of `draw_sheet()`.
- Added `docs/README.md`, `examples/README.md` and the two example sheet images.

### 2024-12-16

- Added `drawing_sheet_sizes.scad` and `draw_sheet()`.
- Split the library into `src/dd_dimlines.scad`, `src/dd_sheet.scad` and `src/dd_titleblock.scad`, included from
  `dimdraft.scad`.
- Added `ddtemplates.scad` with `titleblock0`, `titleblock1` and `revblock0` under `templates/`.

### 2024-12-15

- Moved the samples to `examples/`, with one file per view.

### 2024-12-14

- Renamed `dimensions.scad` to `dimdraft.scad`.
- Switched to OpenSCAD's built-in `text()`, and removed the text generator.
- Added the `SCALING_FACTOR`, `LINE_WIDTH`, `SPACE` and `HEIGHT` overrides.
- Removed the pixel art module, which moved to its own repository.

### 2024-01-12

- Added a pixel art module.

### 2024-01-09

- Reorganised `dimlines.scad` into `dimensions.scad` and `title_blocks.scad`.

### 2024-01-08

- Imported from [pwpearson/dimensional-drawings](https://github.com/pwpearson/dimensional-drawings).

[Unreleased]: https://github.com/CameronBrooks11/DraftSCAD/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/CameronBrooks11/DraftSCAD/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/CameronBrooks11/DraftSCAD/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/CameronBrooks11/DraftSCAD/releases/tag/v0.1.0
