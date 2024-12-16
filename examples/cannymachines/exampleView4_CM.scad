include <examplePart_CM.scad>;
ROTATION4 = [135, 45, 0];

module exampleView4_CM(docHeight = 1)
{
    // view 4
    rotate(ROTATION4) sample_part();
}