// A number for fill stops with the assert, where 1 used to draw the white slab.
// expect-error: titleblock0\(\): fill must be true or false
include <../ddtemplates.scad>
include <../dimdraft.scad>

titleblock0(["a", "b", "c", "d", "e"], ["a", "b", "c", "d"], ["a", "b", "c"], fill=1);
