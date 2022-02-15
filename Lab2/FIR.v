`timescale 1ns / 1ps

module FIR(
clk,
rst,
a,b,c,
x,
y
);

input clk,rst;
input[7:0] a,b,c;
input[7:0] x;
output[7:0] y;

reg[7:0] x_1,x_2; 

wire[7:0] r0,r1,r2;

// r0 = a*x;
// r1 = b*x1;
// r2 = c*x2;
multiply m0(a,x,r0);
multiply m1(b,x_1,r1);
multiply m2(c,x_2,r2);

// y = a*x + b*x1 + c*x2;
assign y=r0+r1+r2;

always@(posedge clk or negedge rst)begin
    if(~rst)begin
        x_1<=0;
        x_2<=0;
    end
    else begin
        x_1<=x;
        x_2<=x_1;
    end
end

endmodule
