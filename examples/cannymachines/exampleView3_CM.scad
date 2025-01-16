include <example_CM_config.scad>;

include <../../dimdraft.scad>;
include <examplePart_CM.scad>;

ROTATION3 = [ 0, 90, 90 ];

module exampleView3_CM()
{
    // view 3
    rotate(ROTATION3) sample_part();

    union()
    {

        translate([ -cm_part_width, cm_part_height + DIM_SPACE * 3, 0 ]) dimensions(cm_part_width, loc = DIM_CENTER);

        // extension lines
        union()
        {
            translate([ -cm_part_width, cm_part_height + DIM_SPACE, 0 ]) line(length = DIM_SPACE * 4, vert = true);

            translate([ 0, cm_part_height + DIM_SPACE, 0 ]) line(length = DIM_SPACE * 4, vert = true);
        }

        // right side
        rotate([ 0, 0, -90 ]) union()
        {

            translate([ -cm_part_height * 2, DIM_SPACE * 3, 0 ]) line(length = DIM_SPACE * 3);

            translate([ cm_part_height, DIM_SPACE * 3, 0 ]) leader_line(
                angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_length = .25, text = str(cm_part_height));

            translate([ -cm_part_height, DIM_SPACE * 6, 0 ])
                line(length = cm_part_height * 2, left_arrow = true, right_arrow = true);

            // leader line for dimension
            translate([ cm_part_height, DIM_SPACE * 6, 0 ]) leader_line(
                angle = 0, radius = 0, angle_length = -DIM_SPACE, horz_length = .25, text = str(cm_part_height * 2));
        }

        // extension lines
        union()
        {
            translate([ DIM_SPACE, cm_part_height, 0 ]) line(length = DIM_SPACE * 6);

            translate([ DIM_SPACE, 0, 0 ]) line(length = DIM_SPACE * 3);

            translate([ DIM_SPACE, -cm_part_height, 0 ]) line(length = DIM_SPACE * 6);
        }
    }
}

exampleView3_CM();