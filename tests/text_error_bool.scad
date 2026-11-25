// A boolean label stops with the assert, instead of being drawn as "true".
// expect-error: dimensions\(\): text must be a string or a finite number
include <../dimdraft.scad>

dimensions(length=1, text=true);
