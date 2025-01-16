include <example_DS_config.scad>;

include <../../dimdraft.scad>;
include <examplePart_DS.scad>;

module exampleView2_DS()
{

    rotate([ 90, 0, 0 ]) mypart();

    translate([ 0, 0, DOC_HEIGHT ]) union()
    {

        circle_center(radius = partRadius);

        circle_center(radius = holeRadius);

        // leader line
        translate([ 0, 0, 0 ]) leader_line(angle = 135, radius = partRadius, angle_length = 40, horz_length = 20,
                                           direction = DIM_LEFT, text = str("R ", partRadius));

        // leader line
        translate([ 0, 0, 0 ]) leader_line(angle = 150, radius = holeRadius, angle_length = 150, horz_length = 20,
                                           direction = DIM_LEFT, text = str("R ", holeRadius));
    }
}

exampleView2_DS();