// The circle around a leader label must be cut right through at a large scale, and must be drawn on either side.
// At SCALING_FACTOR = 100 the ring is 1 high, so the cut has to be taller than 1.
// Right, label "1": ring radius 18.5, cut radius 16. Left, label "22": ring radius 29, cut radius 26.5.
// expect: cylinder\(.*h = 1, r1 = 18\.5, r2 = 18\.5
// expect: cylinder\(.*h = 2, r1 = 16, r2 = 16
// expect: cylinder\(.*h = 1, r1 = 29, r2 = 29
// expect: cylinder\(.*h = 2, r1 = 26\.5, r2 = 26\.5
// reject: h = 0\.05
SCALING_FACTOR = 100;
include <../dimdraft.scad>

leader_line(angle = 45, radius = 0, angle_length = 100, horz_length = 30, text = "1", do_circle = true);
leader_line(angle = 135, radius = 0, angle_length = 100, horz_length = 30, direction = DIM_LEFT, text = "22",
            do_circle = true);
