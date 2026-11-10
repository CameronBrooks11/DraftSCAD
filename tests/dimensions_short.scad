// A centred dimension too short for its label must not produce negative-size geometry.
// At SCALING_FACTOR = 100 the label "30" is about 27 wide, so neither of these has room for it between arrows.
// expect: text = "30"
// expect: text = "5"
// reject: size = \[-
SCALING_FACTOR = 100;
include <../dimdraft.scad>

dimensions(length = 30);
translate([ 0, 100, 0 ]) dimensions(length = 5);
