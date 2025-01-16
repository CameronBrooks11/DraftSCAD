/**
 * @file dd_titleblock.scad
 * @brief Functions for creating title blocks on drawing sheets.
 * @details This file contains functions for creating title blocks on drawing sheets. The titleblock function creates a
 * title block with lines, descriptions, and details based on the given parameters.
 * @copyright (c) 2021 Don Smiley, (c) 2025 Cameron K. Brooks
 */

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
 * - color: Line color.
 * - text_color: Text color.
 * Behavior:
 * - Draws lines and places text (descriptions and details) at specified positions.
 * - Handles horizontal and vertical orientations for text and lines.
 */
module titleblock(lines, descs, details, color = DEF_LINE_COLOR, text_color = DEF_TEXT_COLOR)
{
    DIM_FONTSCALE = DIM_LINE_WIDTH * 0.7;

    for (line = lines)
    {
        color(color) translate([ line[0] * DIM_LINE_WIDTH, line[1] * DIM_LINE_WIDTH, 0 ]) if (line[2] == DIM_VERT)
        {
            rotate([ 0, 0, -90 ]) line(length = line[3] * DIM_LINE_WIDTH, width = DIM_LINE_WIDTH * line[4]);
        }
        else
        {
            line(length = (line[3] + 1) * DIM_LINE_WIDTH, width = DIM_LINE_WIDTH * line[4]);
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