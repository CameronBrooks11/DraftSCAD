---
title: Configuration
parent: Usage
nav_order: 2
---

# Configuration

The library reads six variables when it is included. Set the ones you want **before** the include line. A value
assigned after the include is ignored.

```scad
SCALING_FACTOR = 100;
LINE_COLOR = "MidnightBlue";
include <DraftSCAD/dimdraft.scad>
```

| Variable         | Default                    | Sets                                           |
| ---------------- | -------------------------- | ---------------------------------------------- |
| `SCALING_FACTOR` | `1`                        | A multiplier on line width, height and spacing |
| `LINE_WIDTH`     | `0.025 * SCALING_FACTOR`   | `DIM_LINE_WIDTH`, the width of every line      |
| `HEIGHT`         | `0.01 * SCALING_FACTOR`    | `DIM_LINE_HEIGHT`, the Z thickness of lines    |
| `SPACE`          | `0.1 * SCALING_FACTOR`     | `DIM_SPACE`, the spacing unit                  |
| `LINE_COLOR`     | `"black"`                  | `DEF_LINE_COLOR`                               |
| `TEXT_COLOR`     | `"black"`                  | `DEF_TEXT_COLOR`                               |

These names are plain global variables. If your own code already uses `HEIGHT` or `SPACE` at the top level for
something else, the library will pick that value up.

## What follows from line width

Everything else is derived from `DIM_LINE_WIDTH`.

| Constant           | Value                  | Meaning                                         |
| ------------------ | ---------------------- | ----------------------------------------------- |
| `DIM_FONTSCALE`    | `DIM_LINE_WIDTH * 0.7` | Scale applied to all text                       |
| `DIM_HOLE_CENTER`  | `DIM_LINE_WIDTH * 6`   | Length of the marks drawn by `circle_center()`  |

Text is drawn with OpenSCAD's default size of 10 and then scaled by `DIM_FONTSCALE`, so its height is 7 line widths.
There is no separate text size setting.

With the defaults:

| `SCALING_FACTOR` | `DIM_LINE_WIDTH` | `DIM_SPACE` | Text height |
| ---------------- | ---------------- | ----------- | ----------- |
| `1`              | 0.025            | 0.1         | 0.175       |
| `100`            | 2.5              | 10          | 17.5        |

Setting `LINE_WIDTH` on its own changes the line width and the text size. It does not change `DIM_SPACE`, which
follows `SCALING_FACTOR` only.

## Choosing a scale

Pick `SCALING_FACTOR` so the text is readable next to the part. The two example drawings give a starting point:

- The Canny Machines part is 3.53 units long and uses the default, `1`.
- The Don Smiley part is 400 units across and uses `100`.

`DIM_GRID_SPACING`, the default grid pitch for `draw_sheet()`, is fixed at 50 and does not scale. At a small scale,
pass `grid_dim` yourself.

Title blocks are sized in line widths, so they grow with the scale. See [Title blocks](../reference/title-blocks.md).
