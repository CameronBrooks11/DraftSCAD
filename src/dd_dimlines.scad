









module arrow(arr_points, arr_length, height, color = "black")
{
    /*
     * arrow(arr_points, arr_length, height, color)
     * Creates a triangular arrow pointing to the left with specified dimensions.
     * Parameters:
     * - arr_points: Controls the width of the arrowhead base.
     * - arr_length: Length of the arrowhead.
     * - height: Thickness of the extruded arrow.
     * - color: Optional parameter to set the arrow's color.
     */

    arrowPts = [ [ 0, 0 ], [ arr_points, arr_points / 2 ], [ arr_length, 0 ], [ arr_points, -arr_points / 2 ] ];
    arrowPaths = [[ 0, 1, 2, 3 ]];

    // arrow points to the left
    color(color)
    {
        linear_extrude(height = height, convexity = 2) polygon(points = arrowPts, paths = arrowPaths, convexity = 2);
    }
}

module line(length, width = DIM_LINE_WIDTH, height = DIM_HEIGHT, left_arrow = false, right_arrow = false,
            color = "black")
{
    /*
     * line(length, width, height, left_arrow, right_arrow, color)
     * Draws a line with optional arrows on one or both ends.
     * Parameters:
     * - length: Total length of the line.
     * - width: Thickness of the line (default: DIM_LINE_WIDTH).
     * - height: Extrusion thickness (default: DIM_HEIGHT).
     * - left_arrow, right_arrow: Booleans to include arrows at ends.
     * - color: Optional parameter to set the line's color.
     */

    arr_points = width * 4;
    arr_length = arr_points * .6;
    color(color)
    {
        union()
        {
            if (left_arrow && right_arrow)
            {
                translate([ arr_length, -width / 2, 0 ])
                    cube([ length - arr_length * 2, width, height ], center = false);
            }
            else
            {

                if (left_arrow)
                {
                    translate([ arr_length, -width / 2, 0 ])
                        cube([ length - arr_length, width, height ], center = false);
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
}

module circle_center(radius, size = DIM_HOLE_CENTER, line_width = DIM_LINE_WIDTH, color = "grey")
{
    /*
     * circle_center(radius, size, line_width, color)
     * Creates a visual reference for the center of a circle, including radial lines.
     * Parameters:
     * - radius: Radius of the circle to mark.
     * - size: Length of the lines at the center and circumference.
     * - line_width: Thickness of the radial lines.
     * - color: Optional parameter to set the line color.
     */

    color(color)
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
}

module dimensions(length, line_width = DIM_LINE_WIDTH, loc = DIM_CENTER, color = "black", text_color = "black")
{
    /*
     * dimensions(length, line_width, loc, color, text_color)
     * Adds dimension lines and labels for a given length.
     * Parameters:
     * - length: Distance to dimension.
     * - line_width: Thickness of dimension lines (default: DIM_LINE_WIDTH).
     * - loc: Position of the dimension text (e.g., DIM_CENTER, DIM_LEFT).
     * - color: Color of the dimension lines.
     * - text_color: Color of the text label.
     */

    text = str(length);
    space = len(text) * DIM_FONTSCALE * 7;

    color(color)
    {
        if (loc == DIM_CENTER)
        {
            color(color) line(length = length / 2 - space / 2, width = line_width, height = DIM_HEIGHT,
                              left_arrow = true, right_arrow = false);
            color(color) translate([ length / 2 + space / 2, 0, 0 ])
                line(length = length / 2 - space / 2, width = line_width, height = DIM_HEIGHT, left_arrow = false,
                     right_arrow = true);

            color(text_color) translate([ (length) / 2 - space / 2 * .9, -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
        }
        else
        {

            if (loc == DIM_LEFT)
            {
                color(color) line(length = length, width = line_width, height = DIM_HEIGHT, left_arrow = true,
                                  right_arrow = true);

                color(text_color) translate([ -space, -DIM_FONTSCALE * 3, 0 ])
                    scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
            }
            else
            {
                if (loc == DIM_RIGHT)
                {
                    color(color) line(length = length, width = line_width, height = DIM_HEIGHT, left_arrow = true,
                                      right_arrow = true);

                    color(text_color) translate([ length + space, -DIM_FONTSCALE * 3, 0 ])
                        scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
                }
                else
                {
                    if (loc == DIM_OUTSIDE)
                    {

                        color(color) rotate([ 0, 180, 0 ])
                            line(length = length / 2, width = line_width, height = DIM_HEIGHT, left_arrow = true,
                                 right_arrow = false);
                        color(color) translate([ length, 0, 0 ])
                            line(length = length / 2, width = line_width, height = DIM_HEIGHT, left_arrow = true,
                                 right_arrow = false);
                        color(text_color) translate([ (length) / 2 - space / 2 * .9, -DIM_FONTSCALE * 3, 0 ])
                            scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
                    }
                }
            }
        }
    }
}

module leader_line(angle, radius, angle_length, horz_line_length, direction = DIM_RIGHT, line_width = DIM_LINE_WIDTH,
                   text, do_circle = false, color = "black", text_color = "black")
{
    /*
     * leader_line(angle, radius, angle_length, horz_line_length, direction, line_width, text, do_circle, color,
     * text_color) Draws a leader line pointing to a center with an optional horizontal line and text. Parameters:
     * - angle: Rotation angle for the leader line.
     * - radius: Distance from the center point to the start of the line.
     * - angle_length: Length of the angled portion of the line.
     * - horz_line_length: Length of the horizontal line portion.
     * - direction: Direction of the horizontal line (DIM_RIGHT or DIM_LEFT).
     * - line_width: Thickness of the line.
     * - text: Text annotation for the leader.
     * - do_circle: Boolean to include a circle around the annotation.
     * - color: Color of the lines.
     * - text_color: Color of the annotation text.
     */

    text_length = len(text) * DIM_FONTSCALE * 6;
    space = DIM_FONTSCALE * 6;

    color(color) rotate([ 0, 0, angle ]) translate([ radius, 0, 0 ])
        line(length = angle_length, width = line_width, height = DIM_HEIGHT, left_arrow = true, right_arrow = false);

    rotate([ 0, 0, angle ]) translate([ radius + angle_length, 0, 0 ]) rotate([ 0, 0, -angle ]) union()
    {
        if (direction == DIM_RIGHT)
        {
            color(color) line(length = horz_line_length, width = line_width, height = DIM_HEIGHT, left_arrow = false,
                              right_arrow = false);

            color(text_color) translate([ (horz_line_length + space), -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);

            if (do_circle)
            {
                color(color) translate([ (horz_line_length + space + text_length / 2), 0, 0 ]) difference()
                {
                    cylinder(h = DIM_HEIGHT, r = text_length + space - line_width, center = true, $fn = 100);
                    cylinder(h = .05, r = text_length + space - line_width * 2, center = true, $fn = 100);
                }
            }
        }
        else
        {
            color(color) translate([ -horz_line_length, 0, 0 ])
                line(length = horz_line_length, width = line_width, height = DIM_HEIGHT, left_arrow = false,
                     right_arrow = false);
            color(text_color) translate([ -(horz_line_length + space + text_length), -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
        }
    }
}