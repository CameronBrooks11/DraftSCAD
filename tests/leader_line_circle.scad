// The circle around a leader label must be cut right through at a large scale, must be drawn on either side,
// and must end where the shoulder line ends.
// At SCALING_FACTOR = 100 the ring is 1 high, so the cut has to be taller than 1. The gap before the label is 10.5.
// The ring's outer radius is that gap plus half the label width, so its edge meets the end of the shoulder:
//   right, label "1":  10.5 + 13.517 / 2 = 17.2585, cut radius 14.7585
//   left, label "22":  10.5 + 27.034 / 2 = 24.017,  cut radius 21.517
// expect: cylinder\(.*h = 1, r1 = 17\.2585, r2 = 17\.2585
// expect: cylinder\(.*h = 2, r1 = 14\.7585, r2 = 14\.7585
// expect: cylinder\(.*h = 1, r1 = 24\.017, r2 = 24\.017
// expect: cylinder\(.*h = 2, r1 = 21\.517, r2 = 21\.517
// reject: h = 0\.05
SCALING_FACTOR = 100;
include <../dimdraft.scad>

leader_line(angle = 45, radius = 0, angle_length = 100, horz_length = 30, text = "1", do_circle = true);
leader_line(angle = 135, radius = 0, angle_length = 100, horz_length = 30, direction = DIM_LEFT, text = "22",
            do_circle = true);
