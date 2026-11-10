---
title: Title blocks
parent: Reference
nav_order: 3
---

# Title blocks

`titleblock()` in `src/dd_titleblock.scad` draws any block from three lists. The files in `templates/` are ready-made
blocks built on it.

All title block coordinates and sizes are in **line widths**, not model units. A block 290 units wide is
`290 * DIM_LINE_WIDTH` across: 7.25 at the default scale. A block therefore grows with `SCALING_FACTOR`, and its size
is not tied to the sheet.

## Templates

`include <DraftSCAD/ddtemplates.scad>` provides these. Each has its origin at its **top-left corner** and extends
right and down. Each takes `fill`; when it is true, a white slab is drawn behind the block so a sheet grid does not
show through.

### titleblock0

```scad
titleblock0(part_details, doc_details, org_details, fill = "true")
```

A block 290 wide and 140 tall, in line widths.

| Parameter      | Contents, in order                                            |
| -------------- | ------------------------------------------------------------- |
| `part_details` | Title, material, finish, weight, part number                  |
| `doc_details`  | Drawing number, created by, reviewed by, date of issue        |
| `org_details`  | Logo text, organization name, organization address            |

```scad
include <DraftSCAD/ddtemplates.scad>
include <DraftSCAD/dimdraft.scad>

part_details = [ "My Sample Part", "Stainless Steel", "N/A", "2.5", "123" ];
doc_details = [ "33-2", "D. Smiley", "C. Brooks", "2013-3-31" ];
org_details = [ "My Logo", "Canny Machines", "Org Address, phone" ];

titleblock0(part_details, doc_details, org_details);
```

It is the block at the lower right of the [Canny Machines example](../examples/index.md#canny-machines).

### revblock0

```scad
revblock0(revisions, fill = true)
```

A revision table 121 wide, in line widths, with one row per revision. Its height is `15 * (2 + n)` for `n` revisions.

`revisions` is a list of `[revision, date, initials]`:

```scad
include <DraftSCAD/ddtemplates.scad>
include <DraftSCAD/dimdraft.scad>

revisions = [
    [ "1a", "2013-4-1", "ds" ],
    [ "1b", "2013-4-2", "ds" ],
];

revblock0(revisions);
```

### titleblock1

```scad
titleblock1(fill = true)
```

A block 330 wide and 100 tall, in line widths. Its contents are fixed sample text and cannot be set from outside;
it is a worked example to copy from. It is the block in the [Don Smiley example](../examples/index.md#don-smiley).

## titleblock

```scad
titleblock(lines, descs, details, color = DEF_LINE_COLOR, text_color = DEF_TEXT_COLOR)
```

Draws a block from a list of lines and two lists of text. `descs` is meant for the small captions in each cell and
`details` for the values; the two are drawn the same way.

Every entry in `lines` is `[x, y, orientation, length, width]`:

| Field         | Meaning                                                                         |
| ------------- | ------------------------------------------------------------------------------- |
| `x`, `y`      | Start point                                                                     |
| `orientation` | `DIM_HORZ` runs right from the start point; `DIM_VERT` runs **down** from it    |
| `length`      | Length of the line                                                              |
| `width`       | A multiplier on the line width: `1` is normal, `2` is double                    |

Every entry in `descs` and `details` is `[x, y, orientation, text, size]`:

| Field         | Meaning                                                          |
| ------------- | ---------------------------------------------------------------- |
| `x`, `y`      | Left end of the text baseline                                    |
| `orientation` | `DIM_HORZ`, or `DIM_VERT` to rotate the text 90° anticlockwise   |
| `text`        | The string to draw                                               |
| `size`        | A multiplier on the text size: `1` is normal                     |

```scad
include <DraftSCAD/dimdraft.scad>

// a single cell, 100 wide and 20 tall, with a caption and a value
lines = [
    [ 0, 0, DIM_HORZ, 100, 1 ],
    [ 0, -20, DIM_HORZ, 100, 1 ],
    [ 0, 0, DIM_VERT, 20, 1 ],
    [ 100, 0, DIM_VERT, 20, 1 ],
];
descs = [[ 3, -7, DIM_HORZ, "Material", 0.75 ]];
details = [[ 3, -17, DIM_HORZ, "Stainless Steel", 1 ]];

titleblock(lines, descs, details);
```

To make your own block, copy `templates/titleblock0.scad` and edit its column and row positions.

> **Planned change.** Title blocks are to be generated from parameters, without hand-written templates:
> [#3](https://github.com/CameronBrooks11/DraftSCAD/issues/3).
