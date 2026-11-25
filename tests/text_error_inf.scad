// An infinite label stops with the assert, instead of being drawn as "inf".
// expect-error: dimensions\(\): text must be a string or a finite number
include <../dimdraft.scad>

dimensions(length=1, text=1 / 0);
