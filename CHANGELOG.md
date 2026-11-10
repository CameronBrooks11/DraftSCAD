# Changelog

All notable changes to DraftSCAD are recorded here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- The `TEXT_SIZE` override, read as `DIM_TEXT_SIZE`. It sets the height of dimension and leader labels without
  changing the line width. The default is unchanged at 7 line widths (#2).
- `dd_text_units()`, which estimates the width of a label. It is exact for numbers in the default font (#2).

### Changed

- `dimensions()` centres its label in the break in the line, and sizes the break from the label's estimated width.
  Labels sit slightly differently from 0.1.0 (#2).
- `dimensions()` with `DIM_LEFT` and `DIM_RIGHT` puts the label the same short distance from its arrow on either
  side. The right-hand label used to sit a full label width away (#2).
- A left-hand `leader_line()` label is right-aligned against its shoulder line (#2).
- The circle drawn by `leader_line(do_circle = true)` is sized from the label, so its edge meets the end of the
  shoulder line. It is smaller than in 0.1.0 (#2).

### Fixed

- Dimension labels overlapped arrows and the dimension line, most visibly at a large `SCALING_FACTOR` (#2).
- `dimensions()` with `DIM_CENTER` produced negative-size geometry when the label did not fit. It now draws the
  outside-arrows form (#2).

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

[Unreleased]: https://github.com/CameronBrooks11/DraftSCAD/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/CameronBrooks11/DraftSCAD/releases/tag/v0.1.0
