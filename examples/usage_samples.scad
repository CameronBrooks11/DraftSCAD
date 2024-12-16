include <..\dimdraft.scad>;

module sample_lines(){
    // sample lines
    union() {
        line(length=2, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
            left_arrow=false, right_arrow=false);
        translate([0, -0.25, 0])
        line(length=2, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=true,
            right_arrow=false);
        translate([0, -0.5, 0])
        line(length=2, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
            left_arrow=false, right_arrow=true);
        translate([0, -0.75, 0])
        line(length=2, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=true,
            right_arrow=true);
    }
} 

module sample_dimensions() {

    /* shows all possibilities
        DIM_CENTER = 0;
        DIM_LEFT = 1;
        DIM_RIGHT = 2;
        DIM_OUTSIDE = 3;
    */

    length = 2.5;

    // The following two lines are vertical lines that bracket the dimensions
    // left arrow
    translate([0, -1.75, 0])
    rotate([0, 0, 90])
    line(length=length, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
         left_arrow=false, right_arrow=false);

    // right arrow
    translate([length, -1.75, 0])
    rotate([0, 0, 90])
    line(length=length, width=DIM_LINE_WIDTH, height=DIM_HEIGHT,
         left_arrow=false, right_arrow=false);

    //  The following runs through all the dimension types
    for (i = [0:4]) {
        translate([0, -.5 * i, 0])
        dimensions(length=length, line_width=DIM_LINE_WIDTH, loc=i);
    }
}

module sample_leaderlines() {

    radius = .25;
    for (i = [0:6]) {
        leader_line(angle=i * 15, radius=.25, angle_length=(i * .25),
                    horz_line_length=.5, direction=DIM_RIGHT,
                    line_width=DIM_LINE_WIDTH,
                    text=str("leader line angle: ", i * 15 + 90),
                    do_circle=false
                   );
    }

    for (i = [1:7]) {
        leader_line(angle=i * 20 + 90, radius=.25,
                    angle_length=.75,
                    horz_line_length=.5, direction=DIM_LEFT,
                    line_width=DIM_LINE_WIDTH,
                    text=str("leader line angle: ", i * 20 + 90));
    }
    for (i = [1:4]) {
        leader_line(angle=-i * 20, radius=.25, angle_length=1.5,
                    horz_line_length=.25, direction=DIM_RIGHT,
                    line_width=DIM_LINE_WIDTH,
                    text=str(i),
                    do_circle=true
                   );
    }
 }

module sample_circlecenter() {

    radius = .25;
    difference() {
        cube([1, 1, 1], center=true);
        cylinder(h=1.1, r=radius, center=true, $fn=100);
    }
    color("Black")
    translate([0, 0, .51])
    circle_center(radius=radius, size=DIM_HOLE_CENTER,
        line_width=DIM_LINE_WIDTH);

}

// uncomment these to sample
sample_lines();

translate([-5.5, 0, 0])
sample_dimensions();

translate([4, 0, 0])
sample_circlecenter();

translate([-2, 3, 0])
sample_leaderlines();