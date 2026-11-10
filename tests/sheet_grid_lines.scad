// draw_sheet with a line grid must evaluate with no warning and draw grid lines of the default width and height.
// expect: cube\(size = \[100, 0\.025, 0\.01\]
include <../dimdraft.scad>

draw_sheet(length = 100, height = 100, grid_type = "Grid");
