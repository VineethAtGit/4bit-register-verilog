`timescale 1ns / 1ps

module reg4_tb;
    reg clk;
    reg rst;
    reg s1;
    reg s0;
    reg sin_right;
    reg sin_left;
    wire [3:0] q;

    // Instantiate the Top-Level 4-Bit Register (DUT)
    reg4 uut (
        .clk(clk),
        .rst(rst),
        .s1(s1),
        .s0(s0),
        .sin_right(sin_right),
        .sin_left(sin_left),
        .q(q)
    );

    // Clock Generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    initial begin
        // Setup VCD file generation for GTKWave screenshots
        $dumpfile("output/waveform.vcd");
        $dumpvars(0, reg4_tb);

        // Initialize Signals
        clk = 0;
        rst = 1;
        s1 = 0;
        s0 = 0;
        sin_right = 0;
        sin_left = 0;

        // 1. Test Reset
        #12;
        rst = 0;
        $display("[%0t] INFO: Reset released. q = %b (Expected: 0000)", $time, q);

        // 2. Test Shift Right Mode (s1s0 = 10) with non-symmetric pattern 1101
        s1 = 1; s0 = 0;

        sin_right = 1; #10; // Shift in 1 -> Q3=1
        sin_right = 0; #10; // Shift in 0 -> Q3=0, Q2=1
        sin_right = 1; #10; // Shift in 1 -> Q3=1, Q2=0, Q1=1
        sin_right = 1; #10; // Shift in 1 -> Q3=1, Q2=1, Q1=0, Q0=1
        $display("[%0t] INFO: Shift Right Test: q = %b (Expected: 1101)", $time, q);

        // 3. Test Hold Mode (s1s0 = 00)
        s1 = 0; s0 = 0;
        #20;
        $display("[%0t] INFO: Hold Test: q = %b (Expected: 1101)", $time, q);

        // 4. Test Complement Mode (s1s0 = 01)
        s1 = 0; s0 = 1;
        #10;
        $display("[%0t] INFO: Complement Test: q = %b (Expected: 0010)", $time, q);

        // Return to Hold to stabilize before shift left
        s1 = 0; s0 = 0; #10;

        // 5. Test Shift Left Mode (s1s0 = 11) with non-symmetric pattern 1010
        s1 = 1; s0 = 1;
        sin_left = 0; #10;
        sin_left = 1; #10;
        sin_left = 0; #10;
        sin_left = 1; #10;
        $display("[%0t] INFO: Shift Left Test: q = %b", $time, q);

        // End Simulation
        #30;
        $finish;
    end

    // Console Monitoring
    initial begin
        $monitor("Time=%0t ns | rst=%b s1=%b s0=%b sin_r=%b sin_l=%b | q=%b",
                 $time, rst, s1, s0, sin_right, sin_left, q);
    end

endmodule
