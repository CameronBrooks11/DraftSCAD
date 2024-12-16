include <../../dimdraft.scad>;
include <examplePart_DS.scad>;

module exampleView3_DS()
{
    rotate([ 45, 45, 0 ]) mypart();
}