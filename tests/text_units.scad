// The label width estimate, in font units at text size 10: a digit advances 7.724, a period or a space 3.859.
// "" = 0, "1" = 7.724, "30" = 15.448, "3.53" = 27.031, "1234.5" = 42.479.
// expect: ECHO: 0, 7\.724, 15\.448, 27\.031, 42\.479
include <../dimdraft.scad>

echo(dd_text_units(""), dd_text_units("1"), dd_text_units("30"), dd_text_units("3.53"), dd_text_units("1234.5"));
