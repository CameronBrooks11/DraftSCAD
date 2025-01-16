/**
 * @file dd_dimlines.scad
 * @brief OpenSCAD module for creating dimension lines and annotations.
 * @details This module provides functions for creating dimension lines and annotations in OpenSCAD. The module includes
 * functions for creating dimension lines, leader lines, and annotations. The module also includes functions for
 * creating arrows, circles, and lines. The module is intended to be used in conjunction with other OpenSCAD modules to
 * create technical drawings and other visualizations.
 * @copyright (c) 2021 Don Smiley, (c) 2025 Cameron K. Brooks
 */

/*
 * arrow(arr_points, arr_length, height, color)
 * Creates a triangular arrow pointing to the left with specified dimensions.
 * Parameters:
 * - arr_points: Controls the width of the arrowhead base.
 * - arr_length: Length of the arrowhead.
 * - height: Thickness of the extruded arrow.
 * - color: Optional parameter to set the arrow's color.
 */
module arrow(arr_points, arr_length, height, color = DEF_LINE_COLOR)
{
    arrowPts = [ [ 0, 0 ], [ arr_points, arr_points / 2 ], [ arr_length, 0 ], [ arr_points, -arr_points / 2 ] ];
    arrowPaths = [[ 0, 1, 2, 3 ]];

    // arrow points to the left
    color(color)
    {
        linear_extrude(height = height, convexity = 2) polygon(points = arrowPts, paths = arrowPaths, convexity = 2);
    }
}

/*
 * line(length, width, height, left_arrow, right_arrow, color)
 * Draws a line with optional arrows on one or both ends.
 * Parameters:
 * - length: Total length of the line.
 * - width: Thickness of the line (default: DIM_LINE_WIDTH).
 * - height: Extrusion thickness (default: DIM_LINE_HEIGHT).
 * - left_arrow, right_arrow: Booleans to include arrows at ends.
 * - color: Optional parameter to set the line's color.
 */
module line(length, width = DIM_LINE_WIDTH, height = DIM_LINE_HEIGHT, left_arrow = false, right_arrow = false,
            vert = false, color = DEF_LINE_COLOR)
{
    arr_points = width * 4;
    arr_length = arr_points * .6;
    color(color)
    {
        rotate([ 0, 0, (vert ? 90 : 0) ]) union()
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

/*
 * circle_center(radius, size, line_width, color)
 * Creates a visual reference for the center of a circle, including radial lines.
 * Parameters:
 * - radius: Radius of the circle to mark.
 * - size: Length of the lines at the center and circumference.
 * - line_width: Thickness of the radial lines.
 * - color: Optional parameter to set the line color.
 */
module circle_center(radius, size = DIM_HOLE_CENTER, line_width = DIM_LINE_WIDTH, line_height = DIM_LINE_HEIGHT,
                     color = "grey")
{
    color(color)
    {
        translate([ -size / 2, 0, 0 ])
            line(length = size, width = line_width, height = line_height, left_arrow = false, right_arrow = false);

        translate([ radius - size / 2, 0, 0 ])
            line(length = size, width = line_width, height = line_height, left_arrow = false, right_arrow = false);

        translate([ -radius - size / 2, 0, 0 ])
            line(length = size, width = line_width, height = line_height, left_arrow = false, right_arrow = false);

        translate([ 0, -size / 2, 0 ]) rotate([ 0, 0, 90 ])
            line(length = size, width = line_width, height = line_height, left_arrow = false, right_arrow = false);

        translate([ 0, radius - size / 2, 0 ]) rotate([ 0, 0, 90 ])
            line(length = size, width = line_width, height = line_height, left_arrow = false, right_arrow = false);

        translate([ 0, -radius - size / 2, 0 ]) rotate([ 0, 0, 90 ])
            line(length = size, width = line_width, height = line_height, left_arrow = false, right_arrow = false);
    }
}

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
module dimensions(length, line_width = DIM_LINE_WIDTH, line_height = DIM_LINE_HEIGHT, loc = DIM_CENTER,
                  color = DEF_LINE_COLOR, text_color = DEF_TEXT_COLOR)
{
    text = str(length);
    space = len(text) * DIM_FONTSCALE * 7;

    if (loc == DIM_CENTER)
    {
        color(color) line(length = length / 2 - space / 2, width = line_width, height = line_height, left_arrow = true,
                          right_arrow = false);
        color(color) translate([ length / 2 + space / 2, 0, 0 ])
            line(length = length / 2 - space / 2, width = line_width, height = line_height, left_arrow = false,
                 right_arrow = true);

        color(text_color) translate([ (length) / 2 - space / 2 * .9, -DIM_FONTSCALE * 3, 0 ])
            scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
    }
    else
    {

        if (loc == DIM_LEFT)
        {
            color(color)
                line(length = length, width = line_width, height = line_height, left_arrow = true, right_arrow = true);

            color(text_color) translate([ -space, -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
        }
        else
        {
            if (loc == DIM_RIGHT)
            {
                color(color) line(length = length, width = line_width, height = line_height, left_arrow = true,
                                  right_arrow = true);

                color(text_color) translate([ length + space, -DIM_FONTSCALE * 3, 0 ])
                    scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
            }
            else
            {
                if (loc == DIM_OUTSIDE)
                {

                    color(color) rotate([ 0, 180, 0 ])
                        line(length = length / 2, width = line_width, height = line_height, left_arrow = true,
                             right_arrow = false);
                    color(color) translate([ length, 0, 0 ])
                        line(length = length / 2, width = line_width, height = line_height, left_arrow = true,
                             right_arrow = false);
                    color(text_color) translate([ (length) / 2 - space / 2 * .9, -DIM_FONTSCALE * 3, 0 ])
                        scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
                }
            }
        }
    }
}

/*
 * leader_line(angle, radius, angle_length, horz_length, direction, line_width, text, do_circle, color,
 * text_color) Draws a leader line pointing to a center with an optional horizontal line and text. Parameters:
 * - angle: Rotation angle for the leader line.
 * - radius: Distance from the center point to the start of the line.
 * - angle_length: Length of the angled portion of the line.
 * - horz_length: Length of the horizontal line portion.
 * - direction: Direction of the horizontal line (DIM_RIGHT or DIM_LEFT).
 * - line_width: Thickness of the line.
 * - text: Text annotation for the leader.
 * - do_circle: Boolean to include a circle around the annotation.
 * - color: Color of the lines.
 * - text_color: Color of the annotation text.
 */
module leader_line(angle, radius, angle_length, horz_length, direction = DIM_RIGHT, line_width = DIM_LINE_WIDTH,
                   line_height = DIM_LINE_HEIGHT, text, do_circle = false, color = DEF_LINE_COLOR,
                   text_color = DEF_TEXT_COLOR)
{

    text_length = len(text) * DIM_FONTSCALE * 6;
    space = DIM_FONTSCALE * 6;

    color(color) rotate([ 0, 0, angle ]) translate([ radius, 0, 0 ])
        line(length = angle_length, width = line_width, height = line_height, left_arrow = true, right_arrow = false);

    rotate([ 0, 0, angle ]) translate([ radius + angle_length, 0, 0 ]) rotate([ 0, 0, -angle ]) union()
    {
        if (direction == DIM_RIGHT)
        {
            color(color) line(length = horz_length, width = line_width, height = line_height, left_arrow = false,
                              right_arrow = false);

            color(text_color) translate([ (horz_length + space), -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);

            if (do_circle)
            {
                color(color) translate([ (horz_length + space + text_length / 2), 0, 0 ]) difference()
                {
                    cylinder(h = line_height, r = text_length + space - line_width, center = true, $fn = 100);
                    cylinder(h = .05, r = text_length + space - line_width * 2, center = true, $fn = 100);
                }
            }
        }
        else
        {
            color(color) translate([ -horz_length, 0, 0 ])
                line(length = horz_length, width = line_width, height = line_height, left_arrow = false,
                     right_arrow = false);
            color(text_color) translate([ -(horz_length + space + text_length), -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
        }
    }
}