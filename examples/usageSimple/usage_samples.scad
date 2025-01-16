include <../../dimdraft.scad>;

module sample_lines()
{
    spacing = 0.5;

    // sample lines
    union()
    {
        translate([ 1, spacing, 0 ]) line(length = 2);
        translate([ 1, spacing * 2, 0 ]) line(length = 2, left_arrow = true);
        translate([ 1, spacing * 3, 0 ]) line(length = 2, right_arrow = true);
        translate([ 1, spacing * 4, 0 ]) line(length = 2, left_arrow = true, right_arrow = true);
    }
}

module sample_dimensions()
{

    length = 2.5;

    // The following two lines are vertical lines that bracket the dimensions
    // left arrow
    line(length = length, vert = true);

    // right arrow
    translate([ length, 0, 0 ]) line(length = length, vert = true);

    // The following runs through all the dimension location types
    // DIM_CENTER = 0;
    // DIM_LEFT = 1;
    // DIM_RIGHT = 2;
    // DIM_OUTSIDE = 3;
    for (i = [0:3])
    {
        translate([ 0, 0.5 * i + length / 4, 0 ]) dimensions(length = length, loc = i);
    }
}

module sample_leaderlines()
{
    radius = 0.5;

    // Leader lines around the top left
    for (i = [0:6])
    {
        a = i * 15;                        // angle spacing pattern
        t = str("leader line angle: ", a); // label string
        leader_line(angle = a, radius = radius, angle_length = (i * .25), horz_length = 0.5, direction = DIM_RIGHT,
                    text = t, do_circle = false);
    }

    // Leader lines around the right side
    for (i = [1:7])
    {
        a = i * 25 + 80;                   // angle spacing pattern
        t = str("leader line angle: ", a); // label string
        leader_line(angle = a, radius = radius, angle_length = 0.75, horz_length = 0.5, direction = DIM_LEFT, text = t);
    }

    // Leader lines around the bottom right
    for (i = [1:4])
    {
        a = -i * 20; // angle spacing pattern
        t = str(i);  // label string
        leader_line(angle = a, radius = radius, angle_length = 1.5, horz_length = 0.25, direction = DIM_RIGHT, text = t,
                    do_circle = true);
    }
}

module sample_circlecenter()
{

    radius = 0.5;

    // Sample part
    difference()
    {
        cube([ radius * 4, radius * 4, 1 ], center = true);
        cylinder(h = 2, r = radius, center = true, $fn = 100);
    }

    // Sample circle center
    translate([ 0, 0, 0.5 ]) circle_center(radius);
}

// Display the samples
translate([ 0.5, 1, 0 ]) sample_lines();
translate([ 8, 1, 0 ]) sample_dimensions();
translate([ 2.5, 6, 0 ]) sample_circlecenter();
translate([ 9, 6, 0 ]) sample_leaderlines();