/**
*@file titleblock0.scad
*@brief A title block for drawing sheets.
*@copyright (c) 2021 Don Smiley, (c) 2025 Cameron K. Brooks
*/

include <../dimdraft.scad>;

/*
 * titleblock0(part_details, doc_details, org_details, fill)
 * Creates a title block for a drawing sheet.
 * Parameters:
 * - part_details: Array of part details with format:
 *           [material, finish, weight, part_no]
 * - doc_details: Array of document details with format:
 *           [drawing_no, created_by, reviewed_by, date_of_issue]
 * - org_details: Array of organization details with format:
 *           [company_name, address, phone]
 * - fill: Boolean to fill the title block with white (default: true).
 * Behavior:
 * - Draws a title block with headings and part, document, and organization details.
 * - Fills the block with white if fill is true.
 */
module titleblock0(part_details, doc_details, org_details, fill = "true")
{

    row_height = 20;

    cols = [ 0, 110, 174, 290 ];
    title_width = cols[3];

    rows = [
        0, -row_height, -row_height * 2, -row_height * 3, -row_height * 4, -row_height * 5, -row_height * 6,
        -row_height * 7
    ];

    // spacing tweaks to fit into the blocks
    desc_x = 3;      // column offset for start of small text
    desc_y = -7;     // row offset for start of small text
    det_x = 15;      // col offset for start of detail text
    det_y = -17;     // row offset for start of detail text
    desc_size = .75; // relative size of description text

    lines = [
        // horizontal lines
        [ -.5, 0, DIM_HORZ, title_width, 1 ],

        [ cols[2], rows[1], DIM_HORZ, cols[3] - cols[2] - .5, 1 ],
        [ cols[0], rows[2], DIM_HORZ, cols[1] - cols[0] - .5, 1 ],
        [ cols[0], rows[3], DIM_HORZ, cols[3] - .5, 1 ],
        [ cols[0], rows[4], DIM_HORZ, cols[2] - .5, 1 ],
        [ cols[0], rows[5], DIM_HORZ, cols[3] - .5, 1 ],
        [ cols[0], rows[6], DIM_HORZ, cols[2] - .5, 1 ],
        [ cols[0], rows[7], DIM_HORZ, cols[2] - .5, 1 ],

        [ cols[0], rows[7], DIM_HORZ, title_width, 1 ],

        // vertical lines
        [ cols[0], rows[0], DIM_VERT, -rows[7], 1 ],
        [ cols[1], rows[0], DIM_VERT, -rows[7], 1 ],
        [ cols[2], rows[0], DIM_VERT, -rows[7], 1 ],
        [ cols[3], rows[0], DIM_VERT, -rows[7], 1 ],
    ];

    part_desc = [ "Material", "Finish", "Weight", "Part No." ];
    doc_desc = [ "Drawing Number", "Created by", "Reviewed by", "Date of issue" ];

    descs = [

        // part description
        [ cols[0] + desc_x, rows[2] + desc_y, DIM_HORZ, part_desc[0], desc_size ],
        [ cols[0] + desc_x, rows[3] + desc_y, DIM_HORZ, part_desc[1], desc_size ],
        [ cols[0] + desc_x, rows[4] + desc_y, DIM_HORZ, part_desc[2], desc_size ],
        [ cols[0] + desc_x, rows[5] + desc_y, DIM_HORZ, part_desc[3], desc_size ],

        // documentation description
        [ cols[1] + desc_x, rows[3] + desc_y, DIM_HORZ, doc_desc[0], desc_size ],
        [ cols[1] + desc_x, rows[4] + desc_y, DIM_HORZ, doc_desc[1], desc_size ],
        [ cols[1] + desc_x, rows[5] + desc_y, DIM_HORZ, doc_desc[2], desc_size ],
        [ cols[1] + desc_x, rows[6] + desc_y, DIM_HORZ, doc_desc[3], desc_size ],
    ];

    details = [
        [ cols[0] + desc_x, rows[0] + det_y, DIM_HORZ, part_details[0], 1.5 ],
        [ cols[0] + desc_x, rows[2] + det_y, DIM_HORZ, part_details[1], 1 ],
        [ cols[0] + desc_x, rows[3] + det_y, DIM_HORZ, part_details[2], 1 ],
        [ cols[0] + desc_x, rows[4] + det_y, DIM_HORZ, part_details[3], 1 ],
        [ cols[0] + desc_x, rows[5] + det_y, DIM_HORZ, part_details[4], 1 ],

        [ cols[1] + desc_x * 2, rows[3] + det_y, DIM_HORZ, doc_details[0], 1 ],
        [ cols[1] + desc_x * 2, rows[4] + det_y, DIM_HORZ, doc_details[1], 1 ],
        [ cols[1] + desc_x * 2, rows[5] + det_y, DIM_HORZ, doc_details[2], 1 ],
        [ cols[1] + desc_x * 2, rows[6] + det_y, DIM_HORZ, doc_details[3], 1 ],

        // Organization Details
        [ cols[1] + desc_x, rows[1] + det_y, DIM_HORZ, org_details[0], 1.5 ],
        [ cols[2] + desc_x, rows[0] + det_y, DIM_HORZ, org_details[1], 1.5 ],
        [ cols[2] + desc_x, rows[1] + det_y, DIM_HORZ, org_details[2], 1 ],

    ];

    titleblock(lines, descs, details);

    if (fill) {
        color("white") {
            translate([ 0, -row_height * 7 * DIM_LINE_WIDTH, -DIM_LINE_WIDTH ])
                cube([title_width * DIM_LINE_WIDTH, row_height * 7 * DIM_LINE_WIDTH, DIM_LINE_WIDTH]);
        }
    }
}

