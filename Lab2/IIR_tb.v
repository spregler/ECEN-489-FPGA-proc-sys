`timescale 1ns / 1ps

module IIR_tb(
    );

//your code here=============
reg clk, rst;
reg[7:0] x,a,b,c,d;
wire[7:0] y;
IIR iir1(clk,
rst,
a,b,c,d,
x,
y);
initial begin
    clk = 0;
    rst = 0;
    a = 0.5*16;
    b = 256 - 1.5*16;
    c = 2*16;
    d = 256 - 16;
    x = 0;
    #4 rst = 1;
end

always #1 begin
    clk = ~clk;
end

integer n = -5;
always@(posedge clk)begin
    if(rst)begin
        if(n<6)begin
            x<=256 + n*16;
            n<= n + 1;
        end
    end
end
//your code here=============

endmodule
