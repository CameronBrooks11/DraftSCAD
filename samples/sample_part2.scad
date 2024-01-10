DOC_SCALING_FACTOR = 100;
DOC_HEIGHT = 250;

// Dimension positioning constants
DIM_CENTER = 0;
DIM_LEFT = 1;
DIM_RIGHT = 2;
DIM_OUTSIDE = 3;

// Orientation constants
DIM_HORZ = 0;
DIM_VERT = 1;

// Corner positioning constants
DIM_UPPER_LEFT = 0;
DIM_UPPER_RIGHT = 1;
DIM_LOWER_LEFT = 2;
DIM_LOWER_RIGHT = 3;

// Line and text related constants
//DIM_LINE_WIDTH = 0.025; // Width of dimension lines
//DIM_SPACE = 0.1;       // Spacing value for line spacing adjustments
DIM_LINE_WIDTH = .025 * DOC_SCALING_FACTOR;
DIM_SPACE = .1 * DOC_SCALING_FACTOR;
DIM_HEIGHT = 0.01;     // Height of lines
DIM_HOLE_CENTER = DIM_LINE_WIDTH * 6; // Size of the cross within a circle

// Font scale relative to line widths
DIM_FONTSCALE = DIM_LINE_WIDTH * 0.7;

// Offset value for hole length
OFFSET = 0.05; // Added to the hole length to extend past the surface of the cube

use <..\TextGenerator.scad>;
use <..\title_blocks.scad>;
use <..\dimensions.scad>;
use <..\samples.scad>;


PART_HEIGHT = 100;
PART_RADIUS = 200;
HOLE_RADIUS = 50;
SLOT_WIDTH = 30;
SLOT_DEPTH = 50;

module mypart() {

    difference() {
        rotate([90, 0, 0])
        cylinder(h=PART_HEIGHT, r=200, center=true, $fn=100);
        rotate([90, 0, 0])
        cylinder(h=PART_HEIGHT + 1, r=HOLE_RADIUS, center=true, $fn=100);

        translate([0, HOLE_RADIUS / 2, 0])
        cube([SLOT_WIDTH, SLOT_DEPTH + 2, PART_RADIUS * 2 + 1], center=true);
    }
}


translate([-300, 200, 0])
mypart();

translate([-300, 200, DOC_HEIGHT])
color("Black")
union() {
    // upper bracket lines
    // edge of slot
    translate([-SLOT_WIDTH / 2, PART_HEIGHT/ 2 + DIM_SPACE, 0])
    rotate([0, 0, 90])
    line(DIM_SPACE * 2, width=DIM_LINE_WIDTH);

    // edge of slot
    translate([SLOT_WIDTH / 2, PART_HEIGHT/ 2 + DIM_SPACE, 0])
    rotate([0, 0, 90])
    line(DIM_SPACE * 2, width=DIM_LINE_WIDTH);

    // upper dimensions
    // slot
    translate([-SLOT_WIDTH / 2, PART_HEIGHT/ 2 + DIM_SPACE * 2, 0])
    dimensions(SLOT_WIDTH, line_width=DIM_LINE_WIDTH,
        loc=DIM_LEFT);

    // right bracket lines
    // top
    translate([PART_RADIUS + DIM_SPACE, PART_HEIGHT / 2, 0])
    line(DIM_SPACE * 5, width=DIM_LINE_WIDTH);

    // slot depth
    translate([PART_RADIUS + DIM_SPACE, PART_HEIGHT / 2 - SLOT_DEPTH, 0])
    line(DIM_SPACE * 2, width=DIM_LINE_WIDTH);


    // bottom
    translate([PART_RADIUS + DIM_SPACE, -PART_HEIGHT / 2, 0])
    line(DIM_SPACE * 5, width=DIM_LINE_WIDTH);

    // right dimentsions
    translate([PART_RADIUS + DIM_SPACE * 5, -PART_HEIGHT/ 2 , 0])
    rotate([0, 0, 90])
    dimensions(PART_HEIGHT, line_width=DIM_LINE_WIDTH,
        loc=DIM_CENTER);

    // slot depth
    translate([PART_RADIUS + DIM_SPACE * 2, +PART_HEIGHT/ 2 - SLOT_DEPTH, 0])
    rotate([0, 0, 90])
    dimensions(SLOT_DEPTH, line_width=DIM_LINE_WIDTH,
        loc=DIM_OUTSIDE);


    // leader line
    translate([-PART_RADIUS, 0, 0])
    leader_line(angle=135, radius=0, angle_length=40,
                horz_line_length=20,
                direction=DIM_LEFT, line_width=DIM_LINE_WIDTH,
                text=str("R ", PART_RADIUS),
                do_circle=false);
}


translate([400, 000, 0])
rotate([45, 45, 0])
mypart();

translate([-300, -200, 0])
rotate([90, 0, 0])
mypart();

translate([-300, -200, DOC_HEIGHT])
color("Black")
union() {

    circle_center(radius=PART_RADIUS, size=DIM_HOLE_CENTER,
    line_width=DIM_LINE_WIDTH);

    circle_center(radius=HOLE_RADIUS, size=DIM_HOLE_CENTER,
    line_width=DIM_LINE_WIDTH);


    // leader line
    translate([0, 0, 0])
    leader_line(angle=135, radius=PART_RADIUS, angle_length=40,
                horz_line_length=20,
                direction=DIM_LEFT, line_width=DIM_LINE_WIDTH,
                text=str("R ", PART_RADIUS),
                do_circle=false);

    // leader line
    translate([0, 0, 0])
    leader_line(angle=150, radius=HOLE_RADIUS,
                angle_length=150,
                horz_line_length=20,
                direction=DIM_LEFT, line_width=DIM_LINE_WIDTH,
                text=str("R ", HOLE_RADIUS),
                do_circle=false);

}

module draw_frame(length, height, line_width=DIM_LINE_WIDTH) {
    line(length=length, width=line_width);

    translate([0, height, 0])
    line(length=length, width=line_width);

    translate([line_width / 2, line_width / 2, 0])
    rotate([0, 0, 90])
    line(length=height - line_width, width=line_width);

    translate([length - line_width / 2, line_width / 2, 0])
    rotate([0, 0, 90])
    line(length=height - line_width, width=line_width);

}

color("Black")
translate([-750, -650, DOC_HEIGHT])
union() {
    draw_frame(length=1700, height=1100, line_width=DIM_LINE_WIDTH * 2);

    color("Black")
    translate([975, 153, 0])
    sample_titleblock1();
}

