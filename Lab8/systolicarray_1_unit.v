`timescale 1ns / 1ps

module systolicarray_1_unit(
mi1,
mi2,
ai,
outmi1,
outmi2,
out
    );

parameter size=8;    
parameter decimal=4;

input[size-1:0] mi1;
input[size-1:0] mi2;
input[size-1:0] ai;
output[size-1:0] out;
output[size-1:0] outmi1;
output[size-1:0] outmi2;

wire[size-1:0] multi;

multiply #(.width(size),.decimal(decimal)) m0(mi1,mi2,multi);

assign out=multi+ai;

assign outmi1=mi1;
assign outmi2=mi2;

endmodule
