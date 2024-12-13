SCALING_FACTOR = 100;

include <..\dimensions.scad>;

DOC_HEIGHT = 250;

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
    titleblock1();
}


module titleblock1() {
    /* sample titleblock
     *
     * Note the use of double thickness lines around the perimeter. Any line
     * can be adjusted to be thinner or thicker.
     *
     * Note also that since lines are centered on their widths, some adjustments
     * for half-width spacing is needed to avoid a jagged look on corners.
     * You can see that in the horizontal lines in the first section that are
     * offset by 1, which is the half-width of the outside line.
     */
    title_width = 290;
    row_height = 15;

    cols = [-1, 50, 114, 200, 215, 260];
    rows = [0, -row_height, -row_height * 2, -row_height * 3, -row_height * 4];

    // spacing tweaks to fit into the blocks
    desc_x = 2; // column offset for start of small text
    desc_y = -5; // row offset for start of small text
    det_y = -12;  // row offset for start of detail text
    desc_size = .75; // relative size of description text

    lines = [
        // horizontal lines
        [cols[0], rows[0], DIM_HORZ, title_width, 2],
        [cols[0], rows[1], DIM_HORZ, title_width, 1],
        [cols[2], rows[2], DIM_HORZ, title_width - cols[2] - 1, 1],
        [cols[3], rows[3], DIM_HORZ, title_width - cols[3] - 1, 1],
        [cols[0], rows[4] - 1, DIM_HORZ, title_width, 2],

        // vertical lines
        [0, 0, DIM_VERT, row_height * 4, 2],
        [cols[1], rows[0], DIM_VERT, row_height, 1],
        [cols[2], rows[0], DIM_VERT, row_height * 4, 1],
        [cols[3], rows[0], DIM_VERT, row_height * 4, 1],
        [cols[4], rows[3], DIM_VERT, row_height, 1],
        [cols[5], rows[3], DIM_VERT, row_height, 1],
        [title_width - 1, 0, DIM_VERT, row_height * 4, 2],
    ];

    descs = [
        [cols[0] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Responsible dep", desc_size],
        [cols[1] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Technical reference", desc_size],
        [cols[2] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Creator", desc_size],
        [cols[3] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Approval person", desc_size],
        [cols[2] + desc_x, rows[1] + desc_y, DIM_HORZ,
            "Document type", desc_size],
        [cols[3] + desc_x, rows[1] + desc_y, DIM_HORZ,
            "Document status", desc_size],
        [cols[2] + desc_x, rows[2] + desc_y, DIM_HORZ,
            "Title", desc_size],
        [cols[3] + desc_x, rows[2] + desc_y, DIM_HORZ,
            "Identification number", desc_size],
        [cols[3] + desc_x, rows[3] + desc_y, DIM_HORZ,
            "Rev", desc_size],
        [cols[4] + desc_x, rows[3] + desc_y, DIM_HORZ,
            "Date of issue", desc_size],
        [cols[5] + desc_x, rows[3] + desc_y, DIM_HORZ,
            "Sheet", desc_size]
    ];

    details = [
        [cols[0] + desc_x,  rows[0] + det_y, DIM_HORZ,
            " ", 1], //Responsible dep.
        [cols[1] + desc_x, rows[0] + det_y, DIM_HORZ,
            " ", 1], //Technical reference
        [cols[2] + desc_x, rows[0] + det_y, DIM_HORZ,
            "D. Smiley ", 1], //Creator
        [cols[3] + desc_x, rows[0] + det_y, DIM_HORZ,
            " ", 1], //Approval person
        [cols[0] + desc_x + 10, rows[2] + det_y, DIM_HORZ,
            "My OpenSCAD Project", 1],
        [cols[2] + desc_x, rows[1] + det_y, DIM_HORZ,
            " ", 1], //Document type
        [cols[3] + desc_x, rows[1] + det_y, DIM_HORZ,
            "First issue", 1], //Document status
        [cols[2] + desc_x, rows[2] + det_y, DIM_HORZ,
            "Sample Part", 1], //Title
        [cols[3] + desc_x, rows[2] + det_y, DIM_HORZ,
            "123", 1], //Identification number
        [cols[3] + desc_x, rows[3] + det_y, DIM_HORZ,
            " ", 1], //Rev
        [cols[4] + desc_x, rows[3] + det_y, DIM_HORZ,
            "2013-3-31", 1], //Date of issue
        [cols[5] + desc_x, rows[3] + det_y, DIM_HORZ,
            "1/100", 1] //Sheet
    ];


    titleblock(lines, descs, details);
}