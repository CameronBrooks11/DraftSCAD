---
title: Sheets
parent: Reference
nav_order: 2
---

# Sheets

Defined in `src/dd_sheet.scad`.

## draw_sheet

```scad
draw_sheet(length = undef, height = undef, sheet_symbol = undef, line_width = DIM_LINE_WIDTH * 2,
           line_height = DIM_LINE_HEIGHT, grid_type = "None", grid_dim = DIM_GRID_SPACING,
           grid_line_width = DIM_LINE_WIDTH, color = DEF_LINE_COLOR)
```

Draws a rectangular sheet frame with its lower-left corner at the origin, and an optional background grid.

| Parameter         | Meaning                                                                  |
| ----------------- | ------------------------------------------------------------------------ |
| `length`          | Sheet size along X                                                       |
| `height`          | Sheet size along Y                                                       |
| `sheet_symbol`    | A standard sheet name, in place of `length` and `height`                 |
| `line_width`      | Frame line width; twice the normal line width by default                 |
| `grid_type`       | `"None"`, `"Dot"` or `"Grid"`                                            |
| `grid_dim`        | Grid pitch; `DIM_GRID_SPACING` (50) by default                           |
| `grid_line_width` | Dot radius for `"Dot"`, line width for `"Grid"`                          |

```scad
include <DraftSCAD/dimdraft.scad>

translate([ 0, 0, -DIM_LINE_WIDTH ]) draw_sheet(length = 11, height = 8.5, grid_type = "Dot", grid_dim = 0.5);
```

The grid is drawn one line width below the frame. Translating the whole sheet down by a line width, as above, keeps
it behind annotations drawn at Z = 0.

`draw_sheet()` echoes to the console when it looks up a sheet symbol and when no grid is selected.

> **Known issues.**
>
> - `sheet_symbol` does not work. The size is found and then not used, and nothing is drawn. Pass `length` and
>   `height`: [#9](https://github.com/CameronBrooks11/DraftSCAD/issues/9).
> - `grid_type = "Grid"` produces a warning for every grid line. `"Dot"` works:
>   [#10](https://github.com/CameronBrooks11/DraftSCAD/issues/10).

## draw_frame

```scad
draw_frame(length, height, line_width = DIM_LINE_WIDTH, line_height = DIM_LINE_HEIGHT, color = DEF_LINE_COLOR)
```

Draws only the rectangle, with its lower-left corner at the origin. `draw_sheet()` calls it.

## draw_grid

```scad
draw_grid(length, height, type = "None", grid_spacing = DIM_GRID_SPACING, line_width = DIM_LINE_WIDTH / 2,
          line_height = DIM_LINE_HEIGHT, color = "lightgray")
```

Draws only the background pattern over a `length` by `height` area from the origin. `type` is `"None"`, `"Dot"` or
`"Grid"`. Called directly, `"Grid"` works.

## Standard sheet sizes

`drawing_sheet_sizes.scad` defines `sheet_sizes`, a list of `[name, [width, height]]` entries in millimetres, in
portrait orientation.

| Family                | Names                                              |
| --------------------- | -------------------------------------------------- |
| ISO 216 A series      | `A0`, `A1`, `A2`, `A3`, `A4`                       |
| ANSI                  | `ANSI_A`, `ANSI_B`, `ANSI_C`, `ANSI_D`, `ANSI_E`   |
| US architectural      | `ARCH_A`, `ARCH_B`, `ARCH_C`, `ARCH_D`, `ARCH_E`   |
| ASME Y14.1            | `ENG_A`, `ENG_B`, `ENG_C`, `ENG_D`, `ENG_E`        |
| JIS B series          | `B0`, `B1`, `B2`, `B3`, `B4`                       |

Until `sheet_symbol` is fixed, look a size up yourself:

```scad
include <DraftSCAD/dimdraft.scad>

a4 = [for (s = sheet_sizes) if (s[0] == "A4") s[1]][0];
draw_sheet(length = a4[0], height = a4[1]);
```
