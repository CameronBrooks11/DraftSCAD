include <example_CM_config.scad>;

include <examplePart_CM.scad>;

ROTATION4 = [ 135, 45, 0 ];

module exampleView4_CM()
{
    // view 4
    rotate(ROTATION4) sample_part();
}