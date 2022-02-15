`timescale 1ns / 1ps

module FIR_tb(
y
    );

reg clk,rst;
reg[7:0] a,b,c;
reg[7:0] x;
output[7:0] y;


FIR f0(
clk,    // Input: clock.
rst,    // Input: reset.
a,b,c,  // Input: coefficients
x,      // Input: x[n] in each clock cycle.
y       // Output: y[n] in each clock cycle.
);

initial begin
clk=0;
rst=0;
// These are the fix-point numbers in Q(3,4) format.
a=8;//0.5
b=-24;//-1.5
c=32;//2.0
x=0;
#4 rst=1;
end

always #1 begin
    clk<=~clk;
end

integer n = -5;
always@(posedge clk)begin
    if(rst)begin
        if(n<6)begin
            x <= 256 + 16*n;
            n <= n + 1;
        end
    end
end

endmodule
