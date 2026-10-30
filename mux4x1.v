module mux4x1 (
    input  wire i0,
    input  wire i1,
    input  wire i2,
    input  wire i3,
    input  wire s1,
    input  wire s0,
    output wire y
);

    assign y = (s1 == 1'b0 && s0 == 1'b0) ? i0 :
               (s1 == 1'b0 && s0 == 1'b1) ? i1 :
               (s1 == 1'b1 && s0 == 1'b0) ? i2 :
                                            i3;

endmodule
