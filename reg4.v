module reg4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       s1,
    input  wire       s0,
    input  wire       sin_right,
    input  wire       sin_left,
    output wire [3:0] q
);

    wire [3:0] d;
    mux4x1 mux3 (
        .i0(q[3]),
        .i1(~q[3]),
        .i2(sin_right),
        .i3(q[2]),
        .s1(s1),
        .s0(s0),
        .y(d[3])
    );
   
    mux4x1 mux2 (
        .i0(q[2]),
        .i1(~q[2]),
        .i2(q[3]),
        .i3(q[1]),
        .s1(s1),
        .s0(s0),
        .y(d[2])
    );

    mux4x1 mux1 (
        .i0(q[1]),
        .i1(~q[1]),
        .i2(q[2]),
        .i3(q[0]),
        .s1(s1),
        .s0(s0),
        .y(d[1])
    );

    mux4x1 mux0 (
        .i0(q[0]),
        .i1(~q[0]),
        .i2(q[1]),
        .i3(sin_left),
        .s1(s1),
        .s0(s0),
        .y(d[0])
    );

    
    dff ff3 (
        .clk(clk),
        .rst(rst),
        .d(d[3]),
        .q(q[3])
    );

    dff ff2 (
        .clk(clk),
        .rst(rst),
        .d(d[2]),
        .q(q[2])
    );

    dff ff1 (
        .clk(clk),
        .rst(rst),
        .d(d[1]),
        .q(q[1])
    );

    dff ff0 (
        .clk(clk),
        .rst(rst),
        .d(d[0]),
        .q(q[0])
    );

endmodule
