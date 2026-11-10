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
 * dd_text_units(text)
 * Estimates the width of a label in font units, at OpenSCAD's default text size of 10.
 * Multiply by DIM_FONTSCALE for the width as drawn.
 * In the default font every digit advances 7.724 units and a period or a space 3.859, so the estimate is
 * exact for a number. Letters and other fonts differ: "R" advances 10.03 and "M" 11.57.
 */
function dd_text_units(text, i = 0) = i >= len(text)
                                          ? 0
                                          : ((text[i] == "." || text[i] == " ") ? 3.859 : 7.724) +
                                                dd_text_units(text, i + 1);

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

        translate([ 0, -size / 2, 0 ]) line(length = size, width = line_width, height = line_height, vert = true);

        translate([ 0, radius - size / 2, 0 ])
            line(length = size, width = line_width, height = line_height, vert = true);

        translate([ 0, -radius - size / 2, 0 ])
            line(length = size, width = line_width, height = line_height, vert = true);
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
    text_width = dd_text_units(text) * DIM_FONTSCALE;
    pad = DIM_FONTSCALE * 3;       // clear space on each side of a label set into the line
    gap = text_width + pad * 2;    // break in the line for a centred label
    label_gap = DIM_FONTSCALE * 5; // distance from an arrow to a label beside it
    arrowhead = line_width * 4;    // length of an arrowhead, tip to barbs

    // A centred label needs the break, and on each side an arrowhead and as much shaft again.
    fits_centred = length - gap >= arrowhead * 4;
    // Arrows outside the dimension are half its length, and never shorter than two arrowheads.
    outside_length = max(length / 2, arrowhead * 2);

    if (loc == DIM_CENTER && fits_centred)
    {
        color(color) line(length = (length - gap) / 2, width = line_width, height = line_height, left_arrow = true,
                          right_arrow = false);
        color(color) translate([ (length + gap) / 2, 0, 0 ])
            line(length = (length - gap) / 2, width = line_width, height = line_height, left_arrow = false,
                 right_arrow = true);

        color(text_color) translate([ length / 2, -DIM_FONTSCALE * 3, 0 ])
            scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text, halign = "center");
    }
    else if (loc == DIM_LEFT)
    {
        color(color)
            line(length = length, width = line_width, height = line_height, left_arrow = true, right_arrow = true);

        color(text_color) translate([ -label_gap, -DIM_FONTSCALE * 3, 0 ])
            scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text, halign = "right");
    }
    else if (loc == DIM_RIGHT)
    {
        color(color)
            line(length = length, width = line_width, height = line_height, left_arrow = true, right_arrow = true);

        color(text_color) translate([ length + label_gap, -DIM_FONTSCALE * 3, 0 ])
            scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
    }
    else if (loc == DIM_OUTSIDE || loc == DIM_CENTER)
    {
        // Also the fallback for a centred label that does not fit.
        color(color) rotate([ 0, 180, 0 ])
            line(length = outside_length, width = line_width, height = line_height, left_arrow = true,
                 right_arrow = false);
        color(color) translate([ length, 0, 0 ])
            line(length = outside_length, width = line_width, height = line_height, left_arrow = true,
                 right_arrow = false);

        if (gap <= length)
        {
            color(text_color) translate([ length / 2, -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text, halign = "center");
        }
        else
        {
            // no room between the arrows: put the label past the right-hand one
            color(text_color) translate([ length + outside_length + label_gap, -DIM_FONTSCALE * 3, 0 ])
                scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
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
 * - text: Text annotation for the leader. Optional; with none, only the line is drawn.
 * - do_circle: Boolean to include a circle around the annotation.
 * - color: Color of the lines.
 * - text_color: Color of the annotation text.
 */
module leader_line(angle, radius, angle_length, horz_length, direction = DIM_RIGHT, line_width = DIM_LINE_WIDTH,
                   line_height = DIM_LINE_HEIGHT, text = "", do_circle = false, color = DEF_LINE_COLOR,
                   text_color = DEF_TEXT_COLOR)
{

    text_width = dd_text_units(text) * DIM_FONTSCALE;
    space = DIM_FONTSCALE * 6;

    color(color) rotate([ 0, 0, angle ]) translate([ radius, 0, 0 ])
        line(length = angle_length, width = line_width, height = line_height, left_arrow = true, right_arrow = false);

    rotate([ 0, 0, angle ]) translate([ radius + angle_length, 0, 0 ]) rotate([ 0, 0, -angle ]) union()
    {
        if (direction == DIM_RIGHT)
        {
            color(color) line(length = horz_length, width = line_width, height = line_height, left_arrow = false,
                              right_arrow = false);

            if (len(text) > 0)
                color(text_color) translate([ (horz_length + space), -DIM_FONTSCALE * 3, 0 ])
                    scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text);
        }
        else
        {
            color(color) translate([ -horz_length, 0, 0 ])
                line(length = horz_length, width = line_width, height = line_height, left_arrow = false,
                     right_arrow = false);
            if (len(text) > 0)
                color(text_color) translate([ -(horz_length + space), -DIM_FONTSCALE * 3, 0 ])
                    scale([ DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE ]) text(text, halign = "right");
        }

        if (do_circle)
        {
            // centred on the label, on whichever side it was drawn
            circle_x = horz_length + space + text_width / 2;
            // the ring reaches back across the gap, so its edge meets the end of the shoulder line
            ring_radius = space + text_width / 2;
            color(color) translate([ (direction == DIM_RIGHT ? circle_x : -circle_x), 0, 0 ]) difference()
            {
                cylinder(h = line_height, r = ring_radius, center = true, $fn = 100);
                // twice the ring's height, so the cut goes through at any scale
                cylinder(h = line_height * 2, r = ring_radius - line_width, center = true, $fn = 100);
            }
        }
    }
}