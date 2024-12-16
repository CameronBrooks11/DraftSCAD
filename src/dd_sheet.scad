
include <../drawing_sheet_sizes.scad>;

module draw_sheet(length = undef, height = undef, sheet_symbol = undef, line_width = DIM_LINE_WIDTH, color = "black")
{
    // If a sheet symbol is provided, override length and height using the sheet_sizes array
    if (!is_undef(sheet_symbol))
    {
        // Debug: Echo the provided sheet symbol
        echo("Looking for sheet symbol: ", sheet_symbol);

        // Filter matching entries
        matches = [for (sheet = sheet_sizes) if (sheet[0] == sheet_symbol) sheet[1]];

        // Assign dimensions if a match is found
        if (len(matches) > 0)
        {
            length = matches[0][0];
            height = matches[0][1];
            draw_frame(length, height, line_width, color);
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
        draw_frame(length, height, line_width, color);
    }
    else
    {
        echo("Warning: Invalid dimensions. Frame not drawn.");
    }
}

module draw_frame(length, height, line_width = DIM_LINE_WIDTH, color = "black")
{
    color(color)
    {
        line(length = length, width = line_width);

        translate([ 0, height, 0 ]) line(length = length, width = line_width);

        translate([ line_width / 2, line_width / 2, 0 ]) rotate([ 0, 0, 90 ])
            line(length = height - line_width, width = line_width);

        translate([ length - line_width / 2, line_width / 2, 0 ]) rotate([ 0, 0, 90 ])
            line(length = height - line_width, width = line_width);
    }
}