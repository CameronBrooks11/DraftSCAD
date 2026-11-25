// A number as a label is drawn as its digits, as str() writes it, in dimensions() and leader_line().
// expect: text = "3\.33"
// expect: text = "7"
// expect: text = "12"
include <../dimdraft.scad>

dimensions(length=10 / 3, text=3.33);
translate([0, 1, 0]) leader_line(angle=30, radius=0, angle_length=0.5, horz_length=0.3, text=7, do_circle=true);
translate([0, 2, 0])
    leader_line(angle=150, radius=0, angle_length=0.5, horz_length=0.3, direction=DIM_LEFT, text=12);
