//  Sample part -- constants used
cm_part_length = 3.53;
cm_part_width = cm_part_length / 2;
cm_part_height = .15;

cm_hole_y1_offset = 1;
cm_hole_y2_offset = 1.25;

cm_hole1_radius = .25;
cm_hole1_x_offset = .65;

cm_hole2_radius = .175;

cm_hole2_x_offset = 1.35;
cm_hole3_x_offset = 2.25;
cm_hole4_x_offset = 2.75;

ZFITE = 0.01;

module sample_part(length = cm_part_length, width = cm_part_width, height = cm_part_height, hole1_xoffset = cm_hole1_x_offset,
                   hole_y1_offset = cm_hole_y1_offset, hole1_radius = cm_hole1_radius, hole2_xoffset = cm_hole2_x_offset,
                   hole3_xoffset = cm_hole3_x_offset, hole4_xoffset = cm_hole4_x_offset, hole_y2_offset = cm_hole_y2_offset,
                   hole2_radius = cm_hole2_radius)
{
    difference()
    {
        union()
        {
            cube([ length, width, height ], center = false);
            translate([ length / 2, 0, -height ]) cube([ length / 2, width, height ], center = false);
        }

        translate([ hole1_xoffset, hole_y1_offset, -ZFITE / 2 ])
            cylinder(h = height + ZFITE, r = hole1_radius, center = false, $fn = 100);

        translate([ hole2_xoffset, hole_y1_offset, -ZFITE / 2 ])
            cylinder(h = height + ZFITE, r = hole1_radius, center = false, $fn = 100);

        translate([ hole3_xoffset, hole_y2_offset, -height - ZFITE / 2 ])
            cylinder(h = height * 2 + ZFITE, r = hole2_radius, center = false, $fn = 100);

        translate([ hole4_xoffset, hole_y2_offset, -height - ZFITE / 2 ])
            cylinder(h = height * 2 + ZFITE, r = hole2_radius, center = false, $fn = 100);
    }
}

