include <example_CM_config.scad>;

include <../../dimdraft.scad>;
include <examplePart_CM.scad>;

module evqcm_Xdims()
{
    union()
    {
        translate([ 0, cm_part_width + DIM_SPACE * 3, 0 ]) dimensions(cm_hole1_x_offset, loc = DIM_OUTSIDE);

        translate([ 0, cm_part_width + DIM_SPACE * 6, 0 ]) dimensions(cm_hole2_x_offset);

        translate([ 0, cm_part_width + DIM_SPACE * 9, 0 ]) dimensions(cm_hole3_x_offset);

        translate([ 0, cm_part_width + DIM_SPACE * 12, 0 ]) dimensions(cm_hole4_x_offset);

        translate([ 0, cm_part_width + DIM_SPACE * 15, 0 ]) dimensions(cm_part_length);

        // extension lines

        union()
        {
            translate([ 0, cm_part_width + DIM_SPACE, 0 ]) line(length = DIM_SPACE * 17, vert = true);

            translate([ cm_part_length, cm_part_width + DIM_SPACE, 0 ]) line(length = DIM_SPACE * 17, vert = true);

            // extension lines for holes
            translate([ cm_hole1_x_offset, cm_part_width - .4, 0 ])
                line(length = cm_part_width - cm_hole_y1_offset + DIM_SPACE * 0, vert = true);

            translate([ cm_hole2_x_offset, cm_part_width - .4, 0 ])
                line(length = cm_part_width - cm_hole_y1_offset + DIM_SPACE * 3, vert = true);

            translate([ cm_hole3_x_offset, cm_part_width - .2, 0 ])
                line(length = cm_part_width - cm_hole_y2_offset + DIM_SPACE * 7, vert = true);

            translate([ cm_hole4_x_offset, cm_part_width - .2, 0 ])
                line(length = cm_part_width - cm_hole_y2_offset + DIM_SPACE * 10, vert = true);
        }
    }
}

module ev1cm_Ydims()
{
    union()
    {
        rotate([ 0, 0, -90 ])
        {

            translate([ -cm_hole_y1_offset, cm_part_length + DIM_SPACE * 3, 0 ]) dimensions(length = cm_hole_y1_offset);

            translate([ -cm_hole_y2_offset, cm_part_length + DIM_SPACE * 6, 0 ]) dimensions(length = cm_hole_y2_offset);

            translate([ -cm_part_width, cm_part_length + DIM_SPACE * 9, 0 ]) dimensions(length = cm_part_width);
        }

        // extension lines

        translate([ cm_part_length + DIM_SPACE, cm_part_width, 0 ]) line(length = 1);

        translate([ cm_part_length - DIM_SPACE * 4, cm_hole_y1_offset, 0 ]) line(length = DIM_SPACE * 8);

        translate([ cm_part_length - DIM_SPACE * 4, cm_hole_y2_offset, 0 ]) line(length = DIM_SPACE * 11);

        translate([ cm_part_length + DIM_SPACE, 0, 0 ]) line(length = 1);
    }
}

module ev1cm_holepair1()
{

    union()
    {
        translate([ cm_hole1_x_offset, cm_hole_y1_offset, 0 ]) circle_center(cm_hole1_radius);

        translate([ cm_hole2_x_offset, cm_hole_y1_offset, 0 ]) circle_center(cm_hole1_radius);
    }

    leader1_text = str("2X 0 ", cm_hole1_radius * 2);

    union()
    {
        translate([ cm_hole1_x_offset, cm_hole_y1_offset, 0 ])
            leader_line(angle = -70, radius = cm_hole1_radius, angle_length = DIM_SPACE * 12, horz_length = .25,
                        text = leader1_text);
    }
}

module ev1cm_holepair2()
{

    union()
    {

        translate([ cm_hole3_x_offset, cm_hole_y2_offset, 0 ]) circle_center(cm_hole2_radius);

        translate([ cm_hole4_x_offset, cm_hole_y2_offset, 0 ]) circle_center(cm_hole2_radius);
    }

    // leader line for holes
    leader2_text = str("2X 0 ", cm_hole2_radius * 2);
    union()
    {

        translate([ cm_hole3_x_offset, cm_hole_y2_offset, 0 ])
            leader_line(angle = -70, radius = cm_hole2_radius, angle_length = DIM_SPACE * 15.5, horz_length = .25,
                        text = leader2_text);
    }
}

module exampleView1_CM(docHeight = 1)
{
    // view 1
    sample_part();

    // upper (actually x) dimensions
    translate([ 0, 0, docHeight ])
    {
        evqcm_Xdims();

        // right side
        ev1cm_Ydims();

        // hole pair 1
        ev1cm_holepair1();

        // hole pair 2
        ev1cm_holepair2();
    }
}

exampleView1_CM();