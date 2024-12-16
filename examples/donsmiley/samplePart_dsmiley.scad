PART_HEIGHT = 100;
PART_RADIUS = 200;
HOLE_RADIUS = 50;
SLOT_WIDTH = 30;
SLOT_DEPTH = 50;

module mypart() {

    difference() {
        rotate([90, 0, 0])
        cylinder(h=PART_HEIGHT, r=200, center=true, $fn=100);
        rotate([90, 0, 0])
        cylinder(h=PART_HEIGHT + 1, r=HOLE_RADIUS, center=true, $fn=100);

        translate([0, HOLE_RADIUS / 2, 0])
        cube([SLOT_WIDTH, SLOT_DEPTH + 2, PART_RADIUS * 2 + 1], center=true);
    }
}