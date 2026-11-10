// TEXT_SIZE sets the text height on its own: the line width keeps its default.
// expect: ECHO: 0\.025, 1, 0\.1
TEXT_SIZE = 1;
include <../dimdraft.scad>

echo(DIM_LINE_WIDTH, DIM_TEXT_SIZE, DIM_FONTSCALE);
