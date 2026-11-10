// A leader line without a label must evaluate with no warning and draw no text.
// reject: text\(
include <../dimdraft.scad>

leader_line(angle = 30, radius = 1, angle_length = 1, horz_length = 1);
leader_line(angle = 150, radius = 1, angle_length = 1, horz_length = 1, direction = DIM_LEFT);
