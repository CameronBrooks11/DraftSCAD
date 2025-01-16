include <example_DS_config.scad>;

include <../../ddtemplates.scad>;
include <../../dimdraft.scad>;

use <exampleView1_DS.scad>;
use <exampleView2_DS.scad>;
use <exampleView3_DS.scad>;

translate([ 500, 800, 0 ]) exampleView1_DS();

translate([ 500, 400, 0 ]) exampleView2_DS();

translate([ 1200, 600, 0 ]) exampleView3_DS();

sheet_len = 1700;
sheet_height = 1100;
translate([ 0, 0, DOC_HEIGHT - DIM_LINE_WIDTH ])
    draw_sheet(length = sheet_len, height = sheet_height, grid_type = "Dot");

translate([ 875, 254, DOC_HEIGHT ]) titleblock1();

color(DEF_TEXT_COLOR) translate([ DIM_GRID_SPACING * 6, DIM_GRID_SPACING * 1.5, 0 ])
    text(text = str("Grid Scale: ", DIM_GRID_SPACING, " mm"), size = 20, valign = "center", halign = "left",
         font = "Liberation Sans:style=Bold Italic");