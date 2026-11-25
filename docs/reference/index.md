---
title: Reference
nav_order: 4
has_children: true
---

# Reference

Every module and function the library provides, by file.

| Page                                            | Modules                                                                        | Source                                 |
| ----------------------------------------------- | ------------------------------------------------------------------------------ | -------------------------------------- |
| [Lines and dimensions](lines-and-dimensions.md) | `line`, `arrow`, `dimensions`, `leader_line`, `circle_center`, `dd_text_units` | `src/dd_dimlines.scad`                 |
| [Sheets](sheets.md)                             | `draw_sheet`, `draw_frame`, `draw_grid`                                        | `src/dd_sheet.scad`                    |
| [Title blocks](title-blocks.md)                 | `titleblock`, `titleblock0`, `titleblock1`, `revblock0`                        | `src/dd_titleblock.scad`, `templates/` |
| [Constants](constants.md)                       | The `DIM_*` constants                                                          | `dimdraft.scad`                        |

`include <DraftSCAD/dimdraft.scad>` provides everything except the three templates, which come from
`include <DraftSCAD/ddtemplates.scad>`.

Conventions that hold throughout:

- Everything is drawn flat on the XY plane, about `DIM_LINE_HEIGHT` thick, from Z = 0 up; a few parts dip a little
  below, such as an outside arrow, a leader's circle, the sheet grid and a title block's fill. Translate it to where you
  want it.
- Lengths are in the units of your model. The library has no unit of its own.
- `line_width` and `line_height` parameters default to `DIM_LINE_WIDTH` and `DIM_LINE_HEIGHT`, and `color` and
  `text_color` to `DEF_LINE_COLOR` and `DEF_TEXT_COLOR`, except where a page gives another default, as for the sheet
  frame and grid and `circle_center()`.
