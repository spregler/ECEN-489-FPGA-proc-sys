`timescale 1ns / 1ps

module IIR_unfold_tb(
y2k,y2k1
    );

reg clk,rst;
reg[7:0] a,b,c,d;
reg[7:0] x2k,x2k1;
output[7:0] y2k,y2k1;

IIR_unfold u0(
clk,
rst,
a,b,c,d,
x2k,x2k1,
y2k,y2k1
);

initial begin
clk = 0;
rst = 0;
a = 8;      //0.5
b = -24;    //-1.5
c = 32;     //2.0
d = -16;    //-1.0
x2k = 0;
x2k1 = 0;
#4 rst = 1;
end

always #1 begin
    clk <= ~clk;
end
integer i = -5;
always@(posedge clk)begin
    if(rst)begin
        if(i < 6)begin
            x2k <= 256 + i * 16;
            x2k1 <= 256 + i * 16 + 16;
            i = i + 2;
        end
    end
end

endmodule
