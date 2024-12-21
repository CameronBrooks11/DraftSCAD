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

sheet_len = 1700;
sheet_height = 1100;
translate([ 0, 0, DOC_HEIGHT - DIM_LINE_WIDTH ])
    draw_sheet(length = sheet_len, height = sheet_height, grid_type = "Dot");

translate([ 875, 254, DOC_HEIGHT ]) titleblock1();

color("black") translate([ DIM_GRID_SPACING * 6, DIM_GRID_SPACING * 1.5, 0 ])
    text(text = str("Grid Scale: ", DIM_GRID_SPACING, " mm"), size = 20, valign = "center", halign = "left",
         font = "Liberation Sans:style=Bold Italic");