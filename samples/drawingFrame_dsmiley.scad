include <../dimdraft.scad>;

module drawingFrameDS() {
    /* sample titleblock
     *
     * Note the use of double thickness lines around the perimeter. Any line
     * can be adjusted to be thinner or thicker.
     *
     * Note also that since lines are centered on their widths, some adjustments
     * for half-width spacing is needed to avoid a jagged look on corners.
     * You can see that in the horizontal lines in the first section that are
     * offset by 1, which is the half-width of the outside line.
     */
    title_width = 290;
    row_height = 15;

    cols = [-1, 50, 114, 200, 215, 260];
    rows = [0, -row_height, -row_height * 2, -row_height * 3, -row_height * 4];

    // spacing tweaks to fit into the blocks
    desc_x = 2; // column offset for start of small text
    desc_y = -5; // row offset for start of small text
    det_y = -12;  // row offset for start of detail text
    desc_size = .75; // relative size of description text

    lines = [
        // horizontal lines
        [cols[0], rows[0], DIM_HORZ, title_width, 2],
        [cols[0], rows[1], DIM_HORZ, title_width, 1],
        [cols[2], rows[2], DIM_HORZ, title_width - cols[2] - 1, 1],
        [cols[3], rows[3], DIM_HORZ, title_width - cols[3] - 1, 1],
        [cols[0], rows[4] - 1, DIM_HORZ, title_width, 2],

        // vertical lines
        [0, 0, DIM_VERT, row_height * 4, 2],
        [cols[1], rows[0], DIM_VERT, row_height, 1],
        [cols[2], rows[0], DIM_VERT, row_height * 4, 1],
        [cols[3], rows[0], DIM_VERT, row_height * 4, 1],
        [cols[4], rows[3], DIM_VERT, row_height, 1],
        [cols[5], rows[3], DIM_VERT, row_height, 1],
        [title_width - 1, 0, DIM_VERT, row_height * 4, 2],
    ];

    descs = [
        [cols[0] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Responsible dep", desc_size],
        [cols[1] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Technical reference", desc_size],
        [cols[2] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Creator", desc_size],
        [cols[3] + desc_x, rows[0] + desc_y, DIM_HORZ,
            "Approval person", desc_size],
        [cols[2] + desc_x, rows[1] + desc_y, DIM_HORZ,
            "Document type", desc_size],
        [cols[3] + desc_x, rows[1] + desc_y, DIM_HORZ,
            "Document status", desc_size],
        [cols[2] + desc_x, rows[2] + desc_y, DIM_HORZ,
            "Title", desc_size],
        [cols[3] + desc_x, rows[2] + desc_y, DIM_HORZ,
            "Identification number", desc_size],
        [cols[3] + desc_x, rows[3] + desc_y, DIM_HORZ,
            "Rev", desc_size],
        [cols[4] + desc_x, rows[3] + desc_y, DIM_HORZ,
            "Date of issue", desc_size],
        [cols[5] + desc_x, rows[3] + desc_y, DIM_HORZ,
            "Sheet", desc_size]
    ];

    details = [
        [cols[0] + desc_x,  rows[0] + det_y, DIM_HORZ,
            " ", 1], //Responsible dep.
        [cols[1] + desc_x, rows[0] + det_y, DIM_HORZ,
            " ", 1], //Technical reference
        [cols[2] + desc_x, rows[0] + det_y, DIM_HORZ,
            "D. Smiley ", 1], //Creator
        [cols[3] + desc_x, rows[0] + det_y, DIM_HORZ,
            " ", 1], //Approval person
        [cols[0] + desc_x + 10, rows[2] + det_y, DIM_HORZ,
            "My OpenSCAD Project", 1],
        [cols[2] + desc_x, rows[1] + det_y, DIM_HORZ,
            " ", 1], //Document type
        [cols[3] + desc_x, rows[1] + det_y, DIM_HORZ,
            "First issue", 1], //Document status
        [cols[2] + desc_x, rows[2] + det_y, DIM_HORZ,
            "Sample Part", 1], //Title
        [cols[3] + desc_x, rows[2] + det_y, DIM_HORZ,
            "123", 1], //Identification number
        [cols[3] + desc_x, rows[3] + det_y, DIM_HORZ,
            " ", 1], //Rev
        [cols[4] + desc_x, rows[3] + det_y, DIM_HORZ,
            "2013-3-31", 1], //Date of issue
        [cols[5] + desc_x, rows[3] + det_y, DIM_HORZ,
            "1/100", 1] //Sheet
    ];


    titleblock(lines, descs, details);
}