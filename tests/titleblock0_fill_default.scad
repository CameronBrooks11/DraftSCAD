// titleblock0 draws its white slab by default.
// expect: color\(\[1, 1, 1, 1\]\)
include <../ddtemplates.scad>
include <../dimdraft.scad>

titleblock0(["a", "b", "c", "d", "e"], ["a", "b", "c", "d"], ["a", "b", "c"]);
