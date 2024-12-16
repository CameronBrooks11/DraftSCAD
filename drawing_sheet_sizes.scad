// drawing_sheet_sizes.scad
sheet_sizes = [
    // ISO 216 (A-Series)
    [ "A0", [ 841, 1189 ] ], [ "A1", [ 594, 841 ] ], [ "A2", [ 420, 594 ] ], [ "A3", [ 297, 420 ] ],
    [ "A4", [ 210, 297 ] ],

    // ANSI Standard (U.S.)
    [ "ANSI_A", [ 216, 279 ] ],  // 8.5 × 11 inches
    [ "ANSI_B", [ 279, 432 ] ],  // 11 × 17 inches
    [ "ANSI_C", [ 432, 559 ] ],  // 17 × 22 inches
    [ "ANSI_D", [ 559, 864 ] ],  // 22 × 34 inches
    [ "ANSI_E", [ 864, 1118 ] ], // 34 × 44 inches

    // Architectural Sizes (U.S.)
    [ "ARCH_A", [ 229, 305 ] ],  // 9 × 12 inches
    [ "ARCH_B", [ 305, 457 ] ],  // 12 × 18 inches
    [ "ARCH_C", [ 457, 610 ] ],  // 18 × 24 inches
    [ "ARCH_D", [ 610, 914 ] ],  // 24 × 36 inches
    [ "ARCH_E", [ 914, 1219 ] ], // 36 × 48 inches

    // ASME Y14.1 (Engineering Drawings)
    [ "ENG_A", [ 216, 279 ] ],  // Same as ANSI A
    [ "ENG_B", [ 279, 432 ] ],  // Same as ANSI B
    [ "ENG_C", [ 432, 559 ] ],  // Same as ANSI C
    [ "ENG_D", [ 559, 864 ] ],  // Same as ANSI D
    [ "ENG_E", [ 864, 1118 ] ], // Same as ANSI E

    // JIS B-Series (Japan)
    [ "B0", [ 1030, 1456 ] ], [ "B1", [ 728, 1030 ] ], [ "B2", [ 515, 728 ] ], [ "B3", [ 364, 515 ] ],
    [ "B4", [ 257, 364 ] ]
];