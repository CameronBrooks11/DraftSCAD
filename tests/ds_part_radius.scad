// The Don Smiley example part must use its radius parameter for the outer cylinder.
// expect: h = 100, r1 = 50, r2 = 50
// reject: r1 = 200
include <../examples/donsmiley/examplePart_DS.scad>

mypart(radius = 50);
