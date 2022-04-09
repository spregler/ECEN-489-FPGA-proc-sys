`timescale 1ns / 1ps

module systolicarray_2_unit(
clk,
rst,
mi0,
mi1,
//ai,
outmi0, // outmi0 = mi0;
outmi1, // outmi1 = mi1;
out     // out = out + mi0 * mi1;
    );

parameter size=8;    
parameter decimal=4;

input clk,rst;
input[size-1:0] mi0;
input[size-1:0] mi1;
//input[size-1:0] ai;
output reg[size-1:0] out;
output reg[size-1:0] outmi0;
output reg[size-1:0] outmi1;

wire[size-1:0] multi;

multiply #(.width(size),.decimal(decimal)) m0(mi0,mi1,multi);

always@(posedge clk or negedge rst)begin
    if(~rst)begin
        out<=0;
        outmi0<=0;
        outmi1<=0;
    end
    else begin
        out<=out+multi;
        outmi0<=mi0;
        outmi1<=mi1;
    end
end

endmodule
