partHeight = 100;
partRadius = 200;
holeRadius = 50;
slotWidth = 30;
slotDepth = 50;

module mypart(height = partHeight, radius = partRadius, holeRadius = holeRadius, slotWidth = slotWidth,
              slotDepth = slotDepth)
{

    difference()
    {
        rotate([ 90, 0, 0 ]) cylinder(h = height, r = 200, center = true, $fn = 100);
        rotate([ 90, 0, 0 ]) cylinder(h = height + 1, r = holeRadius, center = true, $fn = 100);

        translate([ 0, holeRadius / 2, 0 ]) cube([ slotWidth, slotDepth + 2, radius * 2 + 1 ], center = true);
    }
}