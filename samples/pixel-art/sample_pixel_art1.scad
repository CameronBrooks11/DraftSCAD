use <..\..\pixel_art.scad>

// PixArt, " " space mean nothing
// No limit for size
Pix00 = [
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    " 1 1 1 1 1 1 1 1",
    "1 1 1 1 1 1 1 1 ",
    "0123456789ARGBW%"
    ];

PixAlien = [
    "  G     G  ",
    "   G   G   ",
    "  GGGGGGG  ",
    " GG GGG GG ",
    "GGGGGGGGGGG",
    "G GGGGGGG G",
    "G G     G G",
    "   GG GG   "
    ];

PixHello = [
    "111111111111111111111111111111111111111111111111111111111111111111",
    "                                                                  ",
    " 1   1 11111 1     1      111       1   1  111  1111  1     1111  ",
    " 1   1 1     1     1     1   1      1   1 1   1 1   1 1     1   1 ",
    " 11111 111   1     1     1   1      1 1 1 1   1 1111  1     1   1 ",
    " 1   1 1     1     1     1   1      11 11 1   1 1  1  1     1   1 ",
    " 1   1 11111 11111 11111  111       1   1  111  1   1 11111 1111  ",
    "                                                                  ",
    "111111111111111111111111111111111111111111111111111111111111111111"
    ];

// Pacman red ghost
PixGhost = [
    "   0000   ",
    " 00RRRR00 ",
    " 0RRRRRR0 ",
    "0RRWWRRWW0",
    "0RWWBRWWB0",
    "0RRWWRRWW0",
    "0RRRRRRRR0",
    "0RRRRRRRR0",
    "0RRRRRRRR0",
    "0R0R00R0R0"
    ];
    
PixHeart = [
    "    R   R     ",
    "   RRR RRR   ",
    "  RRRRRRRRR  ",
    " RRRRRRRRRRR ",
    " RRRRRRRRRRR ",
    "  RRRRRRRRR  ",
    "   RRRRRRR   ",
    "    RRRRR    ",
    "     RRR     ",
    "      R      "
];

//------------------------------------------------------------
// Main
//------------------------------------------------------------
//PixArt(H=Pix00);
//PixArt(H=PixAlien);
//PixArt(H=PixHello);
//PixArt(H=PixGhost);
PixArt(H=PixHeart);