include <../../dimdraft.scad>;
include <examplePart_CM.scad>;

ROTATION2 = [90, 0, 0];


module exampleView2_CM(docHeight = 1)
{
    // view 2
    // rotate 90 degrees around the y axis
    rotate(ROTATION2) sample_part();

    // dimension lines on the TOP
    translate([ 0, 0, docHeight ]) union()
    {
        translate([ 0, cm_part_height + DIM_SPACE * 3, DIM_HEIGHT ])
            dimensions(cm_part_length / 2, DIM_LINE_WIDTH, loc = DIM_CENTER);

        translate([ 0, cm_part_height + DIM_SPACE * 6, DIM_HEIGHT ]) dimensions(cm_part_length, DIM_LINE_WIDTH);

        // extension lines
        rotate([ 0, 0, 90 ]) union()
        {
            translate([ cm_part_height + DIM_SPACE, 0, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 6, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = false);

            translate([ cm_part_height + DIM_SPACE, -cm_part_length / 2, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 3, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = false);

            translate([ cm_part_height + DIM_SPACE, -cm_part_length, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 6, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = false);
        }

        // right side
        rotate([ 0, 0, -90 ]) union()
        {

            translate([ -cm_part_height * 2, cm_part_length + DIM_SPACE * 3, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 3, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = true);

            translate([ cm_part_height, cm_part_length + DIM_SPACE * 3, DIM_HEIGHT ])
                leader_line(angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_line_length = .25,
                            line_width = DIM_LINE_WIDTH, text = str(cm_part_height));

            translate([ -cm_part_height, cm_part_length + DIM_SPACE * 6, DIM_HEIGHT ]) line(
                length = cm_part_height * 2, width = DIM_LINE_WIDTH, height = .01, left_arrow = true, right_arrow = true);

            // leader line for dimension
            translate([ cm_part_height, cm_part_length + DIM_SPACE * 6, DIM_HEIGHT ])
                leader_line(angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_line_length = .25,
                            line_width = DIM_LINE_WIDTH, text = str(cm_part_height * 2));
        }

        // extension lines
        union()
        {
            translate([ cm_part_length + DIM_SPACE, cm_part_height, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 6, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = false);

            translate([ cm_part_length + DIM_SPACE, 0, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 3, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = false);

            translate([ cm_part_length + DIM_SPACE, -cm_part_height, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 6, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = false);
        }
    }
}

exampleView2_CM();