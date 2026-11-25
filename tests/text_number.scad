// A number as a label is drawn as str() writes it, in dimensions() and leader_line().
// expect: text = "3\.33"
// expect: text = "7"
// expect: text = "12"
// An explicit undef draws no label in leader_line(), as leaving text out does, and not the word "undef".
// reject: text = "undef"
include <../dimdraft.scad>

dimensions(length=10 / 3, text=3.33);
translate([0, 1, 0]) leader_line(angle=30, radius=0, angle_length=0.5, horz_length=0.3, text=7, do_circle=true);
translate([0, 2, 0])
    leader_line(angle=150, radius=0, angle_length=0.5, horz_length=0.3, direction=DIM_LEFT, text=12);
translate([0, 3, 0]) leader_line(angle=30, radius=0, angle_length=0.5, horz_length=0.3, text=undef, do_circle=true);
