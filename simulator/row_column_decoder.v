// row_column_decoder.v
// Author: Vignesh Midamaneni
// Description: Selects a single output from a 3x3 matrix based on 2-bit row and column inputs.

module row_column_decoder(
    input [1:0] r,      // 2-bit row input
    input [1:0] c,      // 2-bit column input
    output [8:0] v      // 9-bit one-hot output
);
    wire [3:0] a, b;    // Decoded row and column signals

    // Decode row and column inputs
    decoder d1(r, a);
    decoder d2(c, b);

    // Generate one-hot output for 3x3 matrix (excluding a[0] and b[0])
    and (v[0], a[1], b[1]);  // Row 1, Column 1
    and (v[1], a[1], b[2]);  // Row 1, Column 2
    and (v[2], a[1], b[3]);  // Row 1, Column 3
    and (v[3], a[2], b[1]);  // Row 2, Column 1
    and (v[4], a[2], b[2]);  // Row 2, Column 2
    and (v[5], a[2], b[3]);  // Row 2, Column 3
    and (v[6], a[3], b[1]);  // Row 3, Column 1
    and (v[7], a[3], b[2]);  // Row 3, Column 2
    and (v[8], a[3], b[3]);  // Row 3, Column 3
endmodule

// 2-to-4 Decoder
module decoder(
    input [1:0] i,      // 2-bit input
    output [3:0] o      // 4-bit one-hot output
);
    wire t1, t2;

    not (t1, i[0]);     // t1 = ~i[0]
    not (t2, i[1]);     // t2 = ~i[1]

    and (o[0], t1, t2);     // o[0] = i == 2'b00
    and (o[1], t2, i[0]);   // o[1] = i == 2'b01
    and (o[2], i[1], t1);   // o[2] = i == 2'b10
    and (o[3], i[1], i[0]); // o[3] = i == 2'b11
endmodule
