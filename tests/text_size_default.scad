// Without TEXT_SIZE the text height is 7 line widths, as it was before the setting existed.
// expect: ECHO: 0\.025, 0\.175, 0\.0175
include <../dimdraft.scad>

echo(DIM_LINE_WIDTH, DIM_TEXT_SIZE, DIM_FONTSCALE);
