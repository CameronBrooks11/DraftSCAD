include <example_CM_config.scad>;

include <../../dimdraft.scad>;
include <examplePart_CM.scad>;

ROTATION2 = [ 90, 0, 0 ];

module exampleView2_CM(docHeight = 1)
{
    // view 2
    // rotate 90 degrees around the y axis
    rotate(ROTATION2) sample_part();

    // dimension lines on the TOP
    translate([ 0, 0, docHeight ]) union()
    {
        translate([ 0, cm_part_height + DIM_SPACE * 3, 0 ]) dimensions(cm_part_length / 2, loc = DIM_CENTER);

        translate([ 0, cm_part_height + DIM_SPACE * 6, 0 ]) dimensions(cm_part_length);

        // extension lines
        union()
        {
            translate([ 0, cm_part_height + DIM_SPACE, 0 ]) line(length = DIM_SPACE * 6, vert = true);

            translate([ cm_part_length / 2, cm_part_height + DIM_SPACE, 0 ]) line(length = DIM_SPACE * 3, vert = true);

            translate([ cm_part_length, cm_part_height + DIM_SPACE, 0 ]) line(length = DIM_SPACE * 6, vert = true);
        }

        // right side
        rotate([ 0, 0, -90 ]) union()
        {

            translate([ -cm_part_height * 2, cm_part_length + DIM_SPACE * 3, 0 ])
                line(length = DIM_SPACE * 3, right_arrow = true);

            translate([ cm_part_height, cm_part_length + DIM_SPACE * 3, 0 ]) leader_line(
                angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_length = .25, text = str(cm_part_height));

            translate([ -cm_part_height, cm_part_length + DIM_SPACE * 6, 0 ])
                line(length = cm_part_height * 2, left_arrow = true, right_arrow = true);

            // leader line for dimension
            translate([ cm_part_height, cm_part_length + DIM_SPACE * 6, 0 ]) leader_line(
                angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_length = .25, text = str(cm_part_height * 2));
        }

        // extension lines
        union()
        {
            translate([ cm_part_length + DIM_SPACE, cm_part_height, 0 ]) line(length = DIM_SPACE * 6);

            translate([ cm_part_length + DIM_SPACE, 0, 0 ]) line(length = DIM_SPACE * 3);

            translate([ cm_part_length + DIM_SPACE, -cm_part_height, 0 ]) line(length = DIM_SPACE * 6);
        }
    }
}

exampleView2_CM();