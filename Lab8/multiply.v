`timescale 1ns / 1ps

module multiply(a,b,c);

parameter width=8;
parameter decimal=4;

input [width-1:0] a,b;
output [width-1:0] c;

wire[width*2-1:0] mul0,mul1,ones,ab;

assign ones=(~0);

assign mul0=a[width-1]?((ones<<width)|a):a;
assign mul1=b[width-1]?((ones<<width)|b):b;

assign ab=mul0*mul1;

assign c=ab[width-1+decimal:decimal];

endmodule
