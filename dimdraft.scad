// ----- Variables -----
DOC_SCALING_FACTOR = is_undef(SCALING_FACTOR) ? 1 : SCALING_FACTOR;

// Line and text related constants
DIM_LINE_WIDTH = is_undef(LINE_WIDTH) ? 0.025 * DOC_SCALING_FACTOR : LINE_WIDTH; // Width of dimension lines
DIM_SPACE = is_undef(SPACE) ? 0.1 * DOC_SCALING_FACTOR : SPACE;     // Spacing value for line spacing adjustments
DIM_HEIGHT = is_undef(HEIGHT) ? 0.01 * DOC_SCALING_FACTOR : HEIGHT; // Height of lines

// ----- Dependent Constants -----
// Hole center constant
DIM_HOLE_CENTER = DIM_LINE_WIDTH * 6; // Size of the cross within a circle
// Font scale relative to line widths
DIM_FONTSCALE = DIM_LINE_WIDTH * 0.7;

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

// Offset value for hole length
ZFITE = 0.05; // Added to the hole length to extend past the surface of the cube

module arrow(arr_points, arr_length, height)
{
    // arrow points to the left
    linear_extrude(height = height, convexity = 2)

        polygon(points =
                    [ [ 0, 0 ], [ arr_points, arr_points / 2 ], [ arr_length, 0 ], [ arr_points, -arr_points / 2 ] ],
                paths = [[ 0, 1, 2, 3 ]], convexity = 2);
}

module line(length, width = DIM_LINE_WIDTH, height = DIM_HEIGHT, left_arrow = false, right_arrow = false)
{
    /* This module draws a line that can have an arrow on either end.  Because
     * the intended use is to be viewed strictly from above, the height of the
     * line is set arbitrarily thin.
     *
     * The factors arr_length and arr_points are used to create a proportionate
     * arrow. Your sense of asthetics may lead you to choose different
     * numbers.
     */

    arr_points = width * 4;
    arr_length = arr_points * .6;

    union()
    {
        if (left_arrow && right_arrow)
        {
            translate([ arr_length, -width / 2, 0 ]) cube([ length - arr_length * 2, width, height ], center = false);
        }
        else
        {

            if (left_arrow)
            {
                translate([ arr_length, -width / 2, 0 ]) cube([ length - arr_length, width, height ], center = false);
            }
            else
            {
                if (right_arrow)
                {
                    translate([ 0, -width / 2, 0 ]) cube([ length - arr_length, width, height ], center = false);
                }
                else
                {
                    translate([ 0, -width / 2, 0 ]) cube([ length, width, height ], center = false);
                }
            }
        }

        if (left_arrow)
        {
            arrow(arr_points, arr_length, height);
        }

        if (right_arrow)
        {
            translate([ length, 0, 0 ]) rotate([ 0, 0, 180 ]) arrow(arr_points, arr_length, height);
        }
    }
}

module circle_center(radius, size = DIM_HOLE_CENTER, line_width = DIM_LINE_WIDTH)
{

    translate([ -size / 2, 0, 0 ])
        line(length = size, width = line_width, height = DIM_HEIGHT, left_arrow = false, right_arrow = false);

    translate([ radius - size / 2, 0, 0 ])
        line(length = size, width = line_width, height = DIM_HEIGHT, left_arrow = false, right_arrow = false);

    translate([ -radius - size / 2, 0, 0 ])
        line(length = size, width = line_width, height = DIM_HEIGHT, left_arrow = false, right_arrow = false);

    translate([ 0, -size / 2, 0 ]) rotate([ 0, 0, 90 ])
        line(length = size, width = line_width, height = DIM_HEIGHT, left_arrow = false, right_arrow = false);

    translate([ 0, radius - size / 2, 0 ]) rotate([ 0, 0, 90 ])
        line(length = size, width = line_width, height = DIM_HEIGHT, left_arrow = false, right_arrow = false);

    translate([ 0, -radius - size / 2, 0 ]) rotate([ 0, 0, 90 ])
        line(length = size, width = line_width, height = DIM_HEIGHT, left_arrow = false, right_arrow = false);
}

module dimensions(length, line_width = DIM_LINE_WIDTH, loc = DIM_CENTER)
{

    text = str(length);
    space = len(text) * DIM_FONTSCALE * 7;

    if (loc == DIM_CENTER)
    {
        line(length = length / 2 - space / 2, width = line_width, height = DIM_HEIGHT, left_arrow = true,
             right_arrow = false);
        translate([ (length) / 2 - space / 2 * .9, -DIM_FONTSCALE * 3, 0 ])
            scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);

        translate([ length / 2 + space / 2, 0, 0 ]) line(length = length / 2 - space / 2, width = line_width,
                                                         height = DIM_HEIGHT, left_arrow = false, right_arrow = true);
    }
    else
    {

        if (loc == DIM_LEFT)
        {
            line(length = length, width = line_width, height = DIM_HEIGHT, left_arrow = true, right_arrow = true);

            translate([ -space, -DIM_FONTSCALE * 3, 0 ]) scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ])
                text(text);
        }
        else
        {
            if (loc == DIM_RIGHT)
            {
                line(length = length, width = line_width, height = DIM_HEIGHT, left_arrow = true, right_arrow = true);

                translate([ length + space, -DIM_FONTSCALE * 3, 0 ])
                    scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
            }
            else
            {
                if (loc == DIM_OUTSIDE)
                {

                    rotate([ 0, 180, 0 ]) line(length = length / 2, width = line_width, height = DIM_HEIGHT,
                                               left_arrow = true, right_arrow = false);

                    translate([ (length) / 2 - space / 2 * .9, -DIM_FONTSCALE * 3, 0 ])
                        scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);

                    translate([ length, 0, 0 ]) line(length = length / 2, width = line_width, height = DIM_HEIGHT,
                                                     left_arrow = true, right_arrow = false);
                }
            }
        }
    }
}

module leader_line(angle, radius, angle_length, horz_line_length, direction = DIM_RIGHT, line_width = DIM_LINE_WIDTH,
                   text, do_circle = false)
{
    /* leader_line
     *
     * Creates a line that points directly at a center point from the given
     * radius.
     * Then, a short horzizontal line is generated, followed by text.  The
     * direction of the horizontal short line defaults to the right, the
     * choice made by either DIM_RIGHT or DIM_LEFT
     */

    text_length = len(text) * DIM_FONTSCALE * 6;
    space = DIM_FONTSCALE * 6;

    rotate([ 0, 0, angle ]) translate([ radius, 0, 0 ])
        line(length = angle_length, width = line_width, height = DIM_HEIGHT, left_arrow = true, right_arrow = false);

    rotate([ 0, 0, angle ]) translate([ radius + angle_length, 0, 0 ]) rotate([ 0, 0, -angle ]) union()
    {
        if (direction == DIM_RIGHT)
        {
            line(length = horz_line_length, width = line_width, height = DIM_HEIGHT, left_arrow = false,
                 right_arrow = false);

            translate([ (horz_line_length + space), -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);

            if (do_circle)
            {
                translate([ (horz_line_length + space + text_length / 2), 0, 0 ]) difference()
                {
                    cylinder(h = DIM_HEIGHT, r = text_length + space - line_width, center = true, $fn = 100);
                    cylinder(h = .05, r = text_length + space - line_width * 2, center = true, $fn = 100);
                }
            }
        }
        else
        {
            translate([ -horz_line_length, 0, 0 ]) line(length = horz_line_length, width = line_width,
                                                        height = DIM_HEIGHT, left_arrow = false, right_arrow = false);

            translate([ -(horz_line_length + space + text_length), -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
        }
    }
}
module titleblock(lines, descs, details)
{
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

    for (line = lines)
    {
        translate([ line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0 ]) if (line[2] == DIM_VERT)
        {
            rotate([ 0, 0, -90 ]) line(length = line[3] * DIM_LINE_WIDTH, width = DIM_LINE_WIDTH * line[4],
                                       height = DIM_HEIGHT, left_arrow = false, right_arrow = false);
        }
        else
        {
            line(length = (line[3] + 1) * DIM_LINE_WIDTH, width = DIM_LINE_WIDTH * line[4], height = DIM_HEIGHT,
                 left_arrow = false, right_arrow = false);
        }
    }

    for (line = descs)
    {
        translate([ line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0 ]) if (line[2] == DIM_VERT)
        {
            rotate([ 0, 0, 90 ]) scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ])
                text(line[3]);
        }
        else
        {
            scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ]) text(line[3]);
        }
    }

    for (line = details)
    {
        translate([ line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0 ]) if (line[2] == DIM_VERT)
        {
            rotate([ 0, 0, 90 ]) scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ])
                text(line[3]);
        }
        else
        {
            scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ]) text(line[3]);
        }
    }
}