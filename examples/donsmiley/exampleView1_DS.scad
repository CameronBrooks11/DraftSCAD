include <example_DS_config.scad>;

include <../../dimdraft.scad>;
include <examplePart_DS.scad>;

module exampleView1_DS()
{
    mypart();
    translate([ 0, 0, DOC_HEIGHT ]) union()
    {
        // upper bracket lines
        // edge of slot
        translate([ -slotWidth / 2, partHeight / 2 + DIM_SPACE, 0 ]) line(DIM_SPACE * 2, vert = true);

        // edge of slot
        translate([ slotWidth / 2, partHeight / 2 + DIM_SPACE, 0 ]) line(DIM_SPACE * 2, vert = true);

        // upper dimensions
        // slot
        translate([ -slotWidth / 2, partHeight / 2 + DIM_SPACE * 2, 0 ]) dimensions(slotWidth, loc = DIM_LEFT);

        // right bracket lines
        // top
        translate([ partRadius + DIM_SPACE, partHeight / 2, 0 ]) line(DIM_SPACE * 5);

        // slot depth
        translate([ partRadius + DIM_SPACE, partHeight / 2 - slotDepth, 0 ]) line(DIM_SPACE * 2);

        // bottom
        translate([ partRadius + DIM_SPACE, -partHeight / 2, 0 ]) line(DIM_SPACE * 5);

        // right dimentsions
        translate([ partRadius + DIM_SPACE * 5, -partHeight / 2, 0 ]) rotate([ 0, 0, 90 ])
            dimensions(partHeight, loc = DIM_CENTER);

        // slot depth
        translate([ partRadius + DIM_SPACE * 2, +partHeight / 2 - slotDepth, 0 ]) rotate([ 0, 0, 90 ])
            dimensions(slotDepth, loc = DIM_OUTSIDE);

        // leader line
        translate([ -partRadius, 0, 0 ])
            leader_line(angle = 135, radius = 0, angle_length = 40, horz_length = 20, direction = DIM_LEFT,
                        text = str("R ", partRadius), do_circle = false);
    }
}

exampleView1_DS();