`timescale 1ns / 1ps

module systolicarray_1_tb(

    );

parameter size=8;
parameter decimal=4;

reg clk,rst;
reg[4*size-1:0] mi0;
reg[4*size-1:0] mi1;
wire[4*size-1:0] mor;

systolicarray_2 s1(clk,rst,mi0,mi1,mor);

initial begin
clk=0;
rst=0;

 
mi0=8|(16<<8)|(16<<16)|(8<<24);     //  mi0 = [8][16][16][8] = [0.5][1][1][0.5].
mi1=16|(32<<8)|(48<<16)|(64<<24);   //  mi1 = [64][48][32][16] = [4][3][2][1].

#4 rst=1;

end

always #1 begin
    clk<=~clk;
end

endmodule
