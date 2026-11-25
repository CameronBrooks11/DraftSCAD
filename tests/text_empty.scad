// An empty dimension label leaves the line unbroken: the right-hand half starts at the middle, 2.5 / 2.
// The pattern names the zero Y offset too: the label's own position, [1.25, -0.0525], is 1.25 either way.
// expect: \[1, 0, 0, 1\.25\], \[0, 1, 0, 0\]
// reject: 1\.3025
include <../dimdraft.scad>

dimensions(length=2.5, text="");
