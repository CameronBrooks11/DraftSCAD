include <../dimdraft.scad>;

module revblock0(revisions, fill = true)
{
    DIM_FONTSCALE = DIM_LINE_WIDTH * .7;

    // revision block headings
    row_height = 15;
    revision_width = 120;
    desc_x = 2;
    desc_y = -10;
    desc_size = 1;

    cols = [ 0, 30, 90, revision_width + 1 ];
    rows = [ 0, -row_height, -row_height * 2 ];

    n_revisions = len(revisions);

    // draw
    linesdef = [
        // vertical lines
        [ cols[0], rows[0], DIM_VERT, row_height * (2 + n_revisions), 1 ],
        [ cols[1], rows[1], DIM_VERT, row_height * (1 + n_revisions), 1 ],
        [ cols[2], rows[1], DIM_VERT, row_height * (1 + n_revisions), 1 ],
        [ cols[3], rows[0], DIM_VERT, row_height * (2 + n_revisions), 1 ],

        // horizontal lines
        [ cols[0], rows[0], DIM_HORZ, revision_width, 1 ],
        [ cols[0], rows[1], DIM_HORZ, revision_width, 1 ],
        [ cols[0], rows[2], DIM_HORZ, revision_width, 1 ],
    ];

    lines =
        concat(linesdef, [for (i = [0:n_revisions])[cols[0], rows[2] - row_height * i, DIM_HORZ, revision_width, 1]]);

    descs = [
        [ cols[0] + desc_x, rows[1] + desc_y, DIM_HORZ, "Rev.", desc_size ],
        [ cols[1] + desc_x, rows[1] + desc_y, DIM_HORZ, "Date", desc_size ],
        [ cols[2] + desc_x, rows[1] + desc_y, DIM_HORZ, "Initials", desc_size ],
        [ cols[1] + desc_x, rows[0] + desc_y, DIM_HORZ, "Revisions", desc_size ],
    ];

    details = [for (rev = [0:n_revisions - 1]) for (col = [0:2])[cols[col] + desc_x, rows[2] + rows[1] * (rev) + desc_y,
                                                                 DIM_HORZ, revisions[rev][col], desc_size]];

    titleblock(lines, descs, details);
    if(fill) {
        color("white") {
            translate([ 0, -row_height * (2 + n_revisions) * DIM_LINE_WIDTH, -DIM_LINE_WIDTH])
                cube([revision_width * DIM_LINE_WIDTH + DIM_LINE_WIDTH, row_height * (2 + n_revisions) * DIM_LINE_WIDTH, DIM_LINE_WIDTH]);
        }
    }
}