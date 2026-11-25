// A list label stops with the assert, instead of being drawn as "[1, 2]".
// expect-error: leader_line\(\): text must be a string or a finite number
include <../dimdraft.scad>

leader_line(angle=30, radius=0, angle_length=0.5, horz_length=0.3, text=[1, 2]);
