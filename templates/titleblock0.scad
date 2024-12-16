include <../dimdraft.scad>;

module titleblock0(part_details, doc_details, org_details)
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
}

module sample_revisionblock()
{
    revisions = [
        [ "1a", "2013-4-1", "ds" ],
        [ "1b", "2013-4-2", "ds" ],
        [ "2a", "2013-4-3", "ds" ],
        [ "3a", "2013-4-5", "ds" ],
        [ "4a", "2013-4-15", "ds" ],
    ];
    
    DIM_FONTSCALE = DIM_LINE_WIDTH * .7;

    // revision block headings
    row_height = 15;
    revision_width = 120;
    desc_x = 2;
    desc_y = -10;
    desc_size = 1;

    cols = [ 0, 30, 80, revision_width ];
    rows = [ 0, -row_height, -row_height * 2 ];

    // draw
    lines = [
        // horizontal lines
        [ cols[0], rows[0], DIM_HORZ, revision_width, 1 ],
        [ cols[0], rows[1], DIM_HORZ, revision_width, 1 ],
        [ cols[0], rows[2], DIM_HORZ, revision_width, 1 ],

        // vertical lines
        [ cols[0], rows[0], DIM_VERT, row_height * 2, 1 ],
        [ cols[1], rows[1], DIM_VERT, row_height, 1 ],
        [ cols[2], rows[1], DIM_VERT, row_height, 1 ],
        [ cols[3], rows[0], DIM_VERT, row_height * 2, 1 ],
    ];

    descs = [
        [ cols[0] + desc_x, rows[1] + desc_y, DIM_HORZ, "Rev.", desc_size ],
        [ cols[1] + desc_x, rows[1] + desc_y, DIM_HORZ, "Date", desc_size ],
        [ cols[2] + desc_x, rows[1] + desc_y, DIM_HORZ, "Initials", desc_size ],
        [ cols[1] + desc_x, rows[0] + desc_y, DIM_HORZ, "Revisions", desc_size ],
    ];

    details = [
        [ cols[0] + desc_x, rows[2] + desc_y, DIM_HORZ, revisions[0][0], desc_size ],
        [ cols[1] + desc_x, rows[2] + desc_y, DIM_HORZ, revisions[0][1], desc_size ],
        [ cols[2] + desc_x, rows[2] + desc_y, DIM_HORZ, revisions[0][2], desc_size ],
    ];
    num_revisions = len(revisions);

    titleblock(lines, descs, details);
}