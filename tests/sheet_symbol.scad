// draw_sheet with a standard sheet name must draw a frame of that size: A4 is 210 x 297.
// The frame is 0.05 wide, so its horizontal lines are 210 long and its vertical lines 297 - 0.05.
// expect: cube\(size = \[210, 0\.05, 0\.01\]
// expect: cube\(size = \[296\.95, 0\.05, 0\.01\]
// reject: Invalid dimensions
include <../dimdraft.scad>

draw_sheet(sheet_symbol = "A4");
