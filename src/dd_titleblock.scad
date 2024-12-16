



module titleblock(lines, descs, details, color = "black", text_color = "black")
{
    /*
     * titleblock(lines, descs, details, color, text_color)
     * Creates a title block for a drawing sheet, including lines, descriptions, and details.
     * Parameters:
     * - lines: Array defining the lines in the title block with format:
     *           [[startx, starty, orientation, length, width], ...]
     *           - orientation: Use DIM_HORZ or DIM_VERT for horizontal/vertical lines.
     *           - width: Factor to scale the line width beyond DIM_LINE_WIDTH.
     * - descs: Array defining descriptive text blocks with format:
     *           [[startx, starty, orientation, text, size], ...]
     *           - size: Factor to scale font size beyond DIM_FONTSCALE.
     * - details: Array defining part-specific details with format:
     *           [[startx, starty, orientation, text, size], ...]
     * - color: Line color (default: "black").
     * - text_color: Text color (default: "black").
     * Behavior:
     * - Draws lines and places text (descriptions and details) at specified positions.
     * - Handles horizontal and vertical orientations for text and lines.
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