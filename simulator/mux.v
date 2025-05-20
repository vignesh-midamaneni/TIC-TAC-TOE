// mux.v
// Author: Vignesh Midamaneni
// Description: 2-to-1 multiplexer using basic gates

module mux (
    input [1:0] in,  // 2-bit input vector
    input sel,       // Select signal
    output o         // Output based on selected input
);
    wire t1, t2, nsel; // Intermediate signals

    not (nsel, sel);           // Invert select signal
    and (t1, sel, in[0]);      // Select in[0] when sel = 1
    and (t2, nsel, in[1]);     // Select in[1] when sel = 0
    or  (o, t1, t2);           // Output the selected input
endmodule
