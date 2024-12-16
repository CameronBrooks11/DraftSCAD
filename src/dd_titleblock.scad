
module titleblock(lines, descs, details, color = "black", text_color = "black")
{
    /* titleblock
     *
     * This module accepts the following arrays with formats:
     *
     * holds the description of the lines. width is a factor that
     * expands the line width beyond DIM_LINE_WIDTH
     *
     * lines     = [[startx, starty, horz/vert, length, width],
     *              [startx, starty, horz/vert, length, width]]
     *
     * holds the descriptions of the title blocks. these are meant to sit in
     * the upper left corner. size, like width above, is a factor that
     * increases/decreases the size of the font
     *
     * descs    = [[startx, starty, horz/vert, text, size],
     *             [startx, starty, horz/vert, text, size]]
     *
     * holds the detail associated with the part being documented
     *
     * details    = [[startx, starty, horz/vert, text, size],
     *               [startx, starty, horz/vert, text, size]]
     */

    DIM_FONTSCALE = DIM_LINE_WIDTH * 0.7;

    for (line = lines)
    {
        color(color) translate([ line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0 ]) if (line[2] == DIM_VERT)
        {
            rotate([ 0, 0, -90 ]) line(length = line[3] * DIM_LINE_WIDTH, width = DIM_LINE_WIDTH * line[4],
                                       height = DIM_HEIGHT, left_arrow = false, right_arrow = false);
        }
        else
        {
            line(length = (line[3] + 1) * DIM_LINE_WIDTH, width = DIM_LINE_WIDTH * line[4], height = DIM_HEIGHT,
                 left_arrow = false, right_arrow = false);
        }
    }

    color(text_color)
    {
        for (line = descs)
        {
            translate([ line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0 ]) if (line[2] == DIM_VERT)
            {
                rotate([ 0, 0, 90 ])
                    scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ]) text(line[3]);
            }
            else
            {
                scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ]) text(line[3]);
            }
        }

        for (line = details)
        {
            translate([ line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0 ]) if (line[2] == DIM_VERT)
            {
                rotate([ 0, 0, 90 ])
                    scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ]) text(line[3]);
            }
            else
            {
                scale([ DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4], DIM_FONTSCALE * line[4] ]) text(line[3]);
            }
        }
    }
}
