include <example_CM_config.scad>;

include <../../ddtemplates.scad>;
include <../../dimdraft.scad>;

// views of the part
use <exampleView1_CM.scad>;
use <exampleView2_CM.scad>;
use <exampleView3_CM.scad>;
use <exampleView4_CM.scad>;

view1Pos = [ 3, 7, 0 ];
translate(view1Pos) exampleView1_CM();

view2Pos = [ 3, 5, 0 ];
translate(view2Pos) exampleView2_CM();

view3Pos = [ 13, 5 + 0.15, 0 ];
translate(view3Pos) exampleView3_CM();

view4Pos = [ 10, 8.5, 0 ];
translate(view4Pos) exampleView4_CM();

// aspects of the part
part_details = [
    "My Sample Part",  // title
    "Stainless Steel", // material
    "N/A",             // finish
    "2.5",             // weight
    "123",             // part no
];

// aspects documenting the creation of the part
doc_details = [
    "33-2",      // Drawing No.
    "D. Smiley", // Created by
    "C. Brooks", // Reviewd by
    "2013-3-31", // Date
];

// the organization making the part
org_details = [ "My Logo", "Canny Machines", "Org Address, phone" ];

// title block
translate([ 9.7, 3.52, 0 ]) titleblock0(part_details, doc_details, org_details);

revisions = [
    [ "1a", "2013-4-1", "ds" ],
    [ "1b", "2013-4-2", "ds" ],
    [ "2a", "2013-4-3", "ds" ],
    [ "3a", "2013-4-5", "ds" ],
    [ "4a", "2013-4-15", "ds" ],
    [ "5a", "2024-12-14", "ckb" ],
    [ "5b", "2024-12-15", "ckb" ],

];

// revision block
translate([ DIM_LINE_WIDTH * 2, 3.4, 0 ]) revblock0(revisions);
sheet_len = 17;
sheet_height = 11;
grid_space = 0.5;
// drawing frame
translate([ 0, 0, -DIM_LINE_WIDTH ])
    draw_sheet(length = sheet_len, height = sheet_height, grid_type = "Dot", grid_dim = 0.5);

color(DEF_TEXT_COLOR) translate([ grid_space * 10, grid_space * 1.5, 0 ])
    text(text = str("Grid Scale: ", grid_space, " mm"), size = grid_space / 2, valign = "center", halign = "left",
         font = "Liberation Sans:style=Bold Italic");