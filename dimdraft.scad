// ----- Variables -----
DOC_SCALING_FACTOR = is_undef(SCALING_FACTOR) ? 1 : SCALING_FACTOR;

// Line and text related constants
DIM_LINE_WIDTH = is_undef(LINE_WIDTH) ? 0.025 * DOC_SCALING_FACTOR : LINE_WIDTH; // Width of dimension lines
DIM_SPACE = is_undef(SPACE) ? 0.1 * DOC_SCALING_FACTOR : SPACE;     // Spacing value for line spacing adjustments
DIM_HEIGHT = is_undef(HEIGHT) ? 0.01 * DOC_SCALING_FACTOR : HEIGHT; // Height of lines

// ----- Dependent Constants -----
// Hole center constant
DIM_HOLE_CENTER = DIM_LINE_WIDTH * 6; // Size of the cross within a circle
// Font scale relative to line widths
DIM_FONTSCALE = DIM_LINE_WIDTH * 0.7;

DIM_GRID_SPACING = 50; // Default grid spacing value, standard for most drawings (i.e. ISO, ANSI, etc.)

// ----- Constants -----
// Dimension positioning constants
DIM_CENTER = 0;
DIM_LEFT = 1;
DIM_RIGHT = 2;
DIM_OUTSIDE = 3;

// Orientation constants
DIM_HORZ = 0;
DIM_VERT = 1;

// Corner positioning constants
DIM_UPPER_LEFT = 0;
DIM_UPPER_RIGHT = 1;
DIM_LOWER_LEFT = 2;
DIM_LOWER_RIGHT = 3;

// Offset value for hole length
ZFITE = 0.05; // Added to the hole length to extend past the surface of the cube

include <src/dd_dimlines.scad>;
include <src/dd_sheet.scad>;
include <src/dd_titleblock.scad>;