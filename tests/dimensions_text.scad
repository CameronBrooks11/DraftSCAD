// A custom label replaces str(length), and the break in the line is sized from its width.
// "R 5" is 21.613 font units wide, so the break is (21.613 + 6) * DIM_FONTSCALE = 0.48323 and the right-hand
// segment starts at (2.5 + 0.48323) / 2 = 1.49161. Counting "R" as a digit would give 1.47118.
// expect: text = "R 5"
// expect: \[1, 0, 0, 1\.49161\]
// Without text the label is str(length), as before.
// expect: text = "3\.33333"
include <../dimdraft.scad>

dimensions(length=2.5, text="R 5");
translate([0, 1, 0]) dimensions(length=10 / 3);
