---
title: Configuration
parent: Usage
nav_order: 2
---

# Configuration

The library reads the variables below when it is included. Set the ones you want **before** the include line. A value
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
| `TEXT_SIZE`      | `7 * DIM_LINE_WIDTH`       | `DIM_TEXT_SIZE`, the height of label text      |
| `LINE_COLOR`     | `"black"`                  | `DEF_LINE_COLOR`                               |
| `TEXT_COLOR`     | `"black"`                  | `DEF_TEXT_COLOR`                               |

These names are plain global variables. If your own code already uses `HEIGHT` or `SPACE` at the top level for
something else, the library will pick that value up.

## What follows from line width

Unless you set `TEXT_SIZE`, everything else is derived from `DIM_LINE_WIDTH`.

| Constant           | Value                  | Meaning                                         |
| ------------------ | ---------------------- | ----------------------------------------------- |
| `DIM_TEXT_SIZE`    | `DIM_LINE_WIDTH * 7`   | Height of label text                            |
| `DIM_FONTSCALE`    | `DIM_TEXT_SIZE / 10`   | Scale applied to label text                     |
| `DIM_HOLE_CENTER`  | `DIM_LINE_WIDTH * 6`   | Length of the marks drawn by `circle_center()`  |

Text is drawn with OpenSCAD's default size of 10 and then scaled by `DIM_FONTSCALE`, so by default its height is 7
line widths.

## Text size

Set `TEXT_SIZE` to size the text on its own, without changing the lines:

```scad
TEXT_SIZE = 0.3;
include <DraftSCAD/dimdraft.scad>

dimensions(length = 4);
```

It applies to the labels drawn by `dimensions()` and `leader_line()`. The gap a label needs follows the text size.

Title blocks do not follow it. Their layout is written in line widths for text 7 line widths tall, so their text stays
that size.

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
