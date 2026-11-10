---
title: Constants
parent: Reference
nav_order: 4
---

# Constants

Defined in `dimdraft.scad`.

## Sizes

These are computed when the library is included. [Configuration](../usage/configuration.md) explains how to change
them.

| Constant           | Default at `SCALING_FACTOR = 1` | Meaning                                        |
| ------------------ | ------------------------------- | ---------------------------------------------- |
| `DIM_LINE_WIDTH`   | 0.025                           | Width of every line                            |
| `DIM_LINE_HEIGHT`  | 0.01                            | Z thickness of every line                      |
| `DIM_SPACE`        | 0.1                             | Spacing unit for placing annotations           |
| `DIM_TEXT_SIZE`    | 0.175                           | Height of label text                           |
| `DIM_FONTSCALE`    | 0.0175                          | Scale applied to label text                    |
| `DIM_HOLE_CENTER`  | 0.15                            | Length of the marks drawn by `circle_center()` |
| `DIM_GRID_SPACING` | 50                              | Default grid pitch; does not scale             |
| `DEF_LINE_COLOR`   | `"black"`                       | Default line colour                            |
| `DEF_TEXT_COLOR`   | `"black"`                       | Default text colour                            |

## Label position

For the `loc` parameter of `dimensions()` and the `direction` parameter of `leader_line()`.

| Constant      | Value |
| ------------- | ----- |
| `DIM_CENTER`  | 0     |
| `DIM_LEFT`    | 1     |
| `DIM_RIGHT`   | 2     |
| `DIM_OUTSIDE` | 3     |

## Orientation

For the `orientation` field of `titleblock()` entries.

| Constant   | Value |
| ---------- | ----- |
| `DIM_HORZ` | 0     |
| `DIM_VERT` | 1     |

## Defined and not used

`DIM_UPPER_LEFT`, `DIM_UPPER_RIGHT`, `DIM_LOWER_LEFT`, `DIM_LOWER_RIGHT` and `ZFITE` are defined, and no module in
the library reads them.
