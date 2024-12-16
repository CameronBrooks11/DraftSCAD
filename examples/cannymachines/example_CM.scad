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
use <../../ddtemplates.scad>;

// views of the part
use <exampleView1_CM.scad>;
use <exampleView2_CM.scad>;
use <exampleView3_CM.scad>;
use <exampleView4_CM.scad>;

DOC_HEIGHT = 2;

view1Pos = [ 2, 7, 0 ];
translate(view1Pos) exampleView1_CM(DOC_HEIGHT);

view2Pos = [ 2, 5, 0 ];
translate(view2Pos) exampleView2_CM(DOC_HEIGHT);

view3Pos = [ 13, 5, 0 ];
translate(view3Pos) exampleView3_CM(DOC_HEIGHT);

view4Pos = [ 10, 9, 0 ];
translate(view4Pos) exampleView4_CM(DOC_HEIGHT);

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
translate([ 9.7, 3.5, 0 ]) titleblock0(part_details, doc_details, org_details);

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
translate([ DIM_LINE_WIDTH, 3.4, 0 ]) revblock0(revisions);

// drawing frame
draw_sheet(length = 17, height = 11, line_width = DIM_LINE_WIDTH * 2);
