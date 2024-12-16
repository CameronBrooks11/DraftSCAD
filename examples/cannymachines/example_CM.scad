/* sample_part1.scad
 *
 * This is a sample to illustrate the use of the
 * dimlines.scad program for creating dimension lines in OpenSCAD.
 *
 * Upon runing this program, select ctrl-4 (top view) to see the dimensioning.
 *
 * More on this can be found at http://CannyMachines.com
 * created by Don Smiley
 */
include <../../dimdraft.scad>;
use <exampleTitleblock_CM.scad>;

use <exampleView1_CM.scad>;
use <exampleView2_CM.scad>;
use <exampleView3_CM.scad>;
use <exampleView4_CM.scad>;

DOC_HEIGHT = 2;

exampleView1_CM(DOC_HEIGHT);

ROT2_VIEW = [0, -2.5, 0];
translate(ROT2_VIEW)
exampleView2_CM(DOC_HEIGHT);

ROT3_VIEW = [9, -2, 0];
translate(ROT3_VIEW)
exampleView3_CM(DOC_HEIGHT);

ROT4_VIEW = [7, 2, 0];
translate(ROT4_VIEW)
exampleView4_CM(DOC_HEIGHT);

// drawing frame
translate([-3, -7.0, DOC_HEIGHT])
union() {
    draw_frame(length=17, height=11, line_width=DIM_LINE_WIDTH * 2);
    translate([9.7, 3.5, 0])
    exampleTitleblockCM();
}
