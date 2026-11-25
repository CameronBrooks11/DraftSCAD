// A string for fill stops with the assert, where "false" used to draw the white slab.
// expect-error: revblock0\(\): fill must be true or false
include <../ddtemplates.scad>
include <../dimdraft.scad>

revblock0([["1a", "2026-1-1", "ab"]], fill="false");
