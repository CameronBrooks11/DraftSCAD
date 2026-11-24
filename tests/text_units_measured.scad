// dd_text_units() agrees with textmetrics() to within 0.001 for every printable ASCII character, " " to "~".
// Needs textmetrics(), which 2021.01 lacks; 2026.10.15 is the version it is known to run on.
// min-openscad: 2026.10.15
// expect: ECHO: "mismatched", \[\]
include <../dimdraft.scad>

echo("mismatched", [for (c = [32:126]) if (abs(dd_text_units(chr(c)) - textmetrics(chr(c)).advance.x) > 0.001) chr(c)]);
