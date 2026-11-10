---
title: Reference
nav_order: 4
has_children: true
---

# Reference

Every module the library provides, by file.

| Page                                              | Modules                                                     | Source                     |
| ------------------------------------------------- | ----------------------------------------------------------- | -------------------------- |
| [Lines and dimensions](lines-and-dimensions.md)   | `line`, `arrow`, `dimensions`, `leader_line`, `circle_center` | `src/dd_dimlines.scad`     |
| [Sheets](sheets.md)                               | `draw_sheet`, `draw_frame`, `draw_grid`                     | `src/dd_sheet.scad`        |
| [Title blocks](title-blocks.md)                   | `titleblock`, `titleblock0`, `titleblock1`, `revblock0`     | `src/dd_titleblock.scad`, `templates/` |
| [Constants](constants.md)                         | The `DIM_*` constants                                       | `dimdraft.scad`            |

`include <DraftSCAD/dimdraft.scad>` provides everything except the three templates, which come from
`include <DraftSCAD/ddtemplates.scad>`.

Conventions that hold throughout:

- Everything is drawn on the XY plane at Z = 0, extruded upward by `DIM_LINE_HEIGHT`. Translate it to where you want it.
- Lengths are in the units of your model. The library has no unit of its own.
- `line_width` and `line_height` parameters default to `DIM_LINE_WIDTH` and `DIM_LINE_HEIGHT`.
- `color` and `text_color` parameters default to `DEF_LINE_COLOR` and `DEF_TEXT_COLOR`.
