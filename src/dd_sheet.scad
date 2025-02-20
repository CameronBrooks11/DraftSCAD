/**
 * @file dd_sheet.scad
 * @brief Functions for drawing sheets from standard sizes and grid patterns.
 * @details This file contains functions for drawing sheets with standard sizes and grid patterns. The draw_sheet
 * function can draw a sheet boundary based on given dimensions or a standard sheet symbol with a grid or dot pattern.
 * @copyright (c) 2025 Cameron K. Brooks, (c) 2021 Don Smiley
 */

include <../drawing_sheet_sizes.scad>;

/*
 * draw_sheet(length, height, sheet_symbol, grid_type, line_width, color)
 * Draws a sheet boundary based on given dimensions or a standard sheet symbol and adds a grid or dot pattern if
 * specified. Parameters:
 * - length: Length of the sheet (overridden if sheet_symbol is provided).
 * - height: Height of the sheet (overridden if sheet_symbol is provided).
 * - sheet_symbol: Standard sheet size identifier (e.g., "A4", "ANSI_B").
 * - grid_type: "None", "Dot", or "Grid" to specify the background pattern.
 * - line_width: Thickness of the sheet boundary lines.
 * - color: Optional parameter to set the frame's color.
 */
module draw_sheet(length = undef, height = undef, sheet_symbol = undef, line_width = DIM_LINE_WIDTH * 2, line_height = DIM_LINE_HEIGHT,
                  grid_type = "None", grid_dim = DIM_GRID_SPACING, grid_line_width = DIM_LINE_WIDTH,
                  color = DEF_LINE_COLOR)
{
    // If a sheet symbol is provided, override length and height using the sheet_sizes array
    if (!is_undef(sheet_symbol))
    {
        echo("Looking for sheet symbol: ", sheet_symbol);
        matches = [for (sheet = sheet_sizes) if (sheet[0] == sheet_symbol) sheet[1]];

        if (len(matches) > 0)
        {
            length = matches[0][0];
            height = matches[0][1];
            echo("Match found for sheet symbol: ", sheet_symbol, " Dimensions: ", matches[0]);
        }
        else
        {
            echo("Warning: Sheet symbol '", sheet_symbol, "' not found.");
        }
    }

    // Proceed only if length and height are defined
    if (!is_undef(length) && !is_undef(height))
    {
        // Draw the grid or dots before drawing the frame to ensure it's in the background
        draw_frame(length, height, line_width, line_height, color);
        translate([ 0, 0, -DIM_LINE_WIDTH ])
            draw_grid(length, height, grid_type, grid_dim, grid_line_width, "lightgray");
    }
    else
    {
        echo("Warning: Invalid dimensions. Frame not drawn.");
    }
}

module draw_frame(length, height, line_width = DIM_LINE_WIDTH, line_height = DIM_LINE_HEIGHT, color = DEF_LINE_COLOR)
{
    /*
     * draw_frame(length, height, line_width, color)
     * Draws the rectangular frame of a sheet with specified dimensions and line width.
     * Parameters:
     * - length: Length of the sheet frame.
     * - height: Height of the sheet frame.
     * - line_width: Thickness of the frame lines.
     * - color: Optional parameter to set the frame's color.
     * Behavior:
     * - Creates a rectangular frame with horizontal and vertical lines.
     */
    color(color)
    {
        // Bottom horizontal line
        line(length = length, width = line_width, height = line_height);

        // Top horizontal line
        translate([ 0, height, 0 ]) line(length = length, width = line_width, height = line_height);

        // Left vertical line
        translate([ line_width / 2, line_width / 2, 0 ]) rotate([ 0, 0, 90 ])
            line(length = height - line_width, width = line_width, height = line_height);

        // Right vertical line
        translate([ length - line_width / 2, line_width / 2, 0 ]) rotate([ 0, 0, 90 ])
            line(length = height - line_width, width = line_width, height = line_height);
    }
}

module draw_grid(length, height, type = "None", grid_spacing = DIM_GRID_SPACING, line_width = DIM_LINE_WIDTH / 2,
                 line_height = DIM_LINE_HEIGHT, color = "lightgray")
{
    /*
     * draw_grid(length, height, type, grid_spacing, line_width, color)
     * Adds a grid or dot pattern to the sheet.
     * Parameters:
     * - length: Length of the sheet.
     * - height: Height of the sheet.
     * - type: "None", "Dot", or "Grid" to specify the background pattern.
     * - grid_spacing: Distance between grid lines or dots.
     * - line_width: Thickness of grid lines (ignored for dots).
     * - color: Color of the grid lines or dots.
     */

    if (type == "Grid")
    {
        color(color)
        {
            // Draw vertical grid lines
            for (x = [0:grid_spacing:length])
            {
                translate([ x, 0, 0 ]) rotate([ 0, 0, 90 ]) // Rotate to vertical
                    line(length = height, width = line_width, height = line_height, left_arrow = false,
                         right_arrow = false);
            }

            // Draw horizontal grid lines
            for (y = [0:grid_spacing:height])
            {
                translate([ 0, y, 0 ]) line(length = length, width = line_width, height = line_height,
                                            left_arrow = false, right_arrow = false);
            }
        }
    }
    else if (type == "Dot")
    {
        color(color)
        {
            // Define dot size
            dot_size = line_width; // You can adjust the dot size as needed

            for (x = [0:grid_spacing:length])
            {
                for (y = [0:grid_spacing:height])
                {
                    translate([ x, y, 0 ]) sphere(r = dot_size, $fn = 12);
                }
            }
        }
    }
    else
    {
        echo("No grid or dot pattern selected.");
    }
}