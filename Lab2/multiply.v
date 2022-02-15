`timescale 1ns / 1ps

module multiply(a,b,c);

parameter width=8;
parameter decimal=4;

input [width-1:0] a,b;
output [width-1:0] c;

wire[width*2-1:0] mul0,mul1,ones,ab;

assign ones=(~0);

// For the multiplication, we first double the bits of a and b, save them in mul0 and mul1.
// If a >= 0: mul0 = [00000000][a7-a0], else : mul0 = [11111111][a7-a0].
// Same for mul1 and b.
assign mul0=a[width-1]?((ones<<width)|a):a;
assign mul1=b[width-1]?((ones<<width)|b):b;

// We have ab to save the 16-bit multiplication result.
assign ab=mul0*mul1;

// We only take the eight middle bits of the result.
assign c=ab[width-1+decimal:decimal];

endmodule
