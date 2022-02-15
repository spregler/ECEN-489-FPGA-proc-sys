`timescale 1ns / 1ps

module IIR_unfold(
clk,
rst,
a,b,c,d,
x2k,x2k1,
y2k,y2k1
);

input clk,rst;
input[7:0] a,b,c,d;
input[7:0] x2k,x2k1;
output[7:0] y2k,y2k1;

reg[7:0] x_1[1:0];
reg[7:0] y_1[1:0],y_2[1:0];


/*************** Your code here ***************/
// UPPER
wire [7:0] r1, r2, r3, r4;
wire [7:0] r5, r6, r7, r8;

multiply m1(x2k, a, r1);
multiply m2(x_1[0], b, r2);
multiply m3(y_1[0], c, r3);
multiply m4(y_2[0], d, r4);

// LOWER
multiply m5(x2k1, a, r5);
multiply m6(x2k, b, r6);
multiply m7(y2k, c, r7);
multiply m8(y_1[0], d, r8);

assign y2k = r1 + r2 + r3 + r4;
assign y2k1 = r5 + r6 + r7 + r8;

always@(posedge clk or negedge rst)begin
    if(~rst)begin
        x_1[0]<=0;
        y_1[0]<=0;
        y_2[0]<=0;
    end
    else begin
        x_1[0]<=x2k1;
        y_1[0]<=y2k1;
        y_2[0]<=y2k;
    end
end
/********************* Done *********************/

endmodule
