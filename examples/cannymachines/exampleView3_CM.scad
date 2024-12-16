include <../../dimdraft.scad>;
include <examplePart_CM.scad>;

ROTATION3 = [0, 90, 90];

module exampleView3_CM(docHeight = 1)
{
    // view 3
    rotate(ROTATION3) sample_part();

    translate([ 0, 0, docHeight ]) union()
    {

        translate([ -cm_part_width, cm_part_height + DIM_SPACE * 3, DIM_HEIGHT ])
            dimensions(cm_part_width, DIM_LINE_WIDTH, loc = DIM_CENTER);

        // extension lines
        rotate([ 0, 0, 90 ]) union()
        {
            translate([ cm_part_height + DIM_SPACE, cm_part_width, DIM_HEIGHT ]) line(length = DIM_SPACE * 4);

            translate([ cm_part_height + DIM_SPACE, 0, DIM_HEIGHT ]) line(length = DIM_SPACE * 4);
        }

        // right side
        rotate([ 0, 0, -90 ]) union()
        {

            translate([ -cm_part_height * 2, DIM_SPACE * 3, DIM_HEIGHT ]) line(
                length = DIM_SPACE * 3, width = DIM_LINE_WIDTH, height = .01, left_arrow = false, right_arrow = true);

            translate([ cm_part_height, DIM_SPACE * 3, DIM_HEIGHT ])
                leader_line(angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_line_length = .25,
                            line_width = DIM_LINE_WIDTH, text = str(cm_part_height));

            translate([ -cm_part_height, DIM_SPACE * 6, DIM_HEIGHT ]) line(
                length = cm_part_height * 2, width = DIM_LINE_WIDTH, height = .01, left_arrow = true, right_arrow = true);

            // leader line for dimension
            translate([ cm_part_height, DIM_SPACE * 6, DIM_HEIGHT ])
                leader_line(angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_line_length = .25,
                            line_width = DIM_LINE_WIDTH, text = str(cm_part_height * 2));
        }

        // extension lines
        union()
        {
            translate([ DIM_SPACE, cm_part_height, DIM_HEIGHT ]) line(length = DIM_SPACE * 6);

            translate([ DIM_SPACE, 0, DIM_HEIGHT ]) line(length = DIM_SPACE * 3);

            translate([ DIM_SPACE, -cm_part_height, DIM_HEIGHT ]) line(length = DIM_SPACE * 6);
        }
    }
}