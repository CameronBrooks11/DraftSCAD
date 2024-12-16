SCALING_FACTOR = 100;

include <../../dimdraft.scad>;
include <examplePart_DS.scad>;

include <../../ddtemplates.scad>;
include <exampleView1_DS.scad>;
include <exampleView2_DS.scad>;
include <exampleView3_DS.scad>;

DOC_HEIGHT = 250;

translate([ 500, 800, 0 ]) exampleView1_DS();

translate([ 500, 400, 0 ]) exampleView2_DS();

translate([ 1200, 600, 0 ]) exampleView3_DS();

translate([ 0, 0, DOC_HEIGHT ]) draw_sheet(length = 1700, height = 1100, line_width = DIM_LINE_WIDTH * 2);

translate([ 975, 155, DOC_HEIGHT ]) titleblock1();