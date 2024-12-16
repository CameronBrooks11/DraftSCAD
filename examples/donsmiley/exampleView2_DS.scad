include <../../dimdraft.scad>;
include <examplePart_DS.scad>;

module exampleView2_DS()
{

    rotate([ 90, 0, 0 ]) mypart();

    translate([ 0, 0, DOC_HEIGHT ]) union()
    {

        circle_center(radius = partRadius, size = DIM_HOLE_CENTER, line_width = DIM_LINE_WIDTH);

        circle_center(radius = holeRadius, size = DIM_HOLE_CENTER, line_width = DIM_LINE_WIDTH);

        // leader line
        translate([ 0, 0, 0 ]) leader_line(angle = 135, radius = partRadius, angle_length = 40, horz_line_length = 20,
                                           direction = DIM_LEFT, line_width = DIM_LINE_WIDTH,
                                           text = str("R ", partRadius), do_circle = false);

        // leader line
        translate([ 0, 0, 0 ]) leader_line(angle = 150, radius = holeRadius, angle_length = 150, horz_line_length = 20,
                                           direction = DIM_LEFT, line_width = DIM_LINE_WIDTH,
                                           text = str("R ", holeRadius), do_circle = false);
    }
}