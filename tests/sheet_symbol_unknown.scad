// An unknown sheet name must say so and draw nothing.
// expect: not found
// reject: cube\(
include <../dimdraft.scad>

draw_sheet(sheet_symbol = "NOT_A_SHEET");
