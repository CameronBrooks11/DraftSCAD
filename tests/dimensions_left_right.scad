// Labels to the left and right of a dimension sit the same distance from it: DIM_FONTSCALE * 5 = 0.0875.
// The left label is right-aligned and ends at -0.0875. The right label starts at 2.5 + 0.0875.
// expect: \[1, 0, 0, -0\.0875\]
// expect: halign = "right"
// expect: \[1, 0, 0, 2\.5875\]
include <../dimdraft.scad>

dimensions(length = 2.5, loc = DIM_LEFT);
translate([ 0, 1, 0 ]) dimensions(length = 2.5, loc = DIM_RIGHT);
