// A string for fill stops with the assert, where "false" used to draw the white slab.
// expect-error: titleblock1\(\): fill must be true or false
include <../ddtemplates.scad>
include <../dimdraft.scad>

titleblock1(fill="false");
