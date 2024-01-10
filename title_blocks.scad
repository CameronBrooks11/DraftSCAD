use <TextGenerator.scad>;
use <dimensions.scad>;

// ----- Constants -----

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
DIM_LINE_WIDTH = 0.025; // Width of dimension lines
DIM_SPACE = 0.1;       // Spacing value for line spacing adjustments
DIM_HEIGHT = 0.01;     // Height of lines
DIM_HOLE_CENTER = DIM_LINE_WIDTH * 6; // Size of the cross within a circle

// Font scale relative to line widths
DIM_FONTSCALE = DIM_LINE_WIDTH * 0.7;

// Offset value for hole length
OFFSET = 0.05; // Added to the hole length to extend past the surface of the cube


module titleblock(lines, descs, details) {
    /* titleblock
     *
     * This module accepts the following arrays with formats:
     *
     * holds the description of the lines. width is a factor that
     * expands the line width beyond DIM_LINE_WIDTH
     *
     * lines     = [[startx, starty, horz/vert, length, width],
     *              [startx, starty, horz/vert, length, width]]
     *
     * holds the descriptions of the title blocks. these are meant to sit in
     * the upper left corner. size, like width above, is a factor that
     * increases/decreases the size of the font
     *
     * descs    = [[startx, starty, horz/vert, text, size],
     *             [startx, starty, horz/vert, text, size]]
     *
     * holds the detail associated with the part being documented
     *
     * details    = [[startx, starty, horz/vert, text, size],
     *               [startx, starty, horz/vert, text, size]]
    */

    DIM_FONTSCALE = DIM_LINE_WIDTH * .7;

    for (line = lines) {
        translate([line[0] * DIM_LINE_WIDTH,
                    line[1] * DIM_LINE_WIDTH,
                    0])
        if (line[2] == DIM_VERT) {
            rotate([0, 0, -90])
            line(length=line[3] * DIM_LINE_WIDTH,
                 width=DIM_LINE_WIDTH * line[4], height=DIM_HEIGHT,
                left_arrow=false, right_arrow=false);
        } else {
            line(length=(line[3] + 1) * DIM_LINE_WIDTH,
                 width=DIM_LINE_WIDTH * line[4], height=DIM_HEIGHT,
                left_arrow=false, right_arrow=false);
        }

    }

    for (line = descs) {
        translate([line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0])
        if (line[2] == DIM_VERT) {
            rotate([0, 0, 90])
            scale([DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4],
                  DIM_FONTSCALE * line[4]])
            drawtext(line[3]);
        } else {
            scale([DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4],
                  DIM_FONTSCALE * line[4]])
            drawtext(line[3]);
        }
    }

    for (line = details) {
        translate([line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0])
        if (line[2] == DIM_VERT) {
            rotate([0, 0, 90])
            scale([DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4],
                  DIM_FONTSCALE * line[4]])
            drawtext(line[3]);
        } else {
            scale([DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4],
                  DIM_FONTSCALE * line[4]])
            drawtext(line[3]);
        }
    }

}