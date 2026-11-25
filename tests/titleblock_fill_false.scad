// With fill = false no template draws its white slab.
// reject: color\(\[1, 1, 1, 1\]\)
include <../ddtemplates.scad>
include <../dimdraft.scad>

titleblock0(["a", "b", "c", "d", "e"], ["a", "b", "c", "d"], ["a", "b", "c"], fill=false);
translate([0, -5, 0]) revblock0([["1a", "2026-1-1", "ab"]], fill=false);
translate([0, -10, 0]) titleblock1(fill=false);
