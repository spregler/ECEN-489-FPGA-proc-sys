`timescale 1ns / 1ps

module butterfly_time(
Fer,	// Real part of the even input.
Fei,	// Imag part of the even input.
For,	// Real part of the odd input.
Foi,	// Imag part of the odd input.
Wr,		// Real part of the weight input.
Wi,		// Imag part of the weight input.
o0r,	// Real part of output 0.
o0i,	// Imag part of output 0.
o1r,	// Real part of output 1.
o1i		// Imag part of output 1.
    );

parameter width=8;
parameter decimal=4;

input[width-1:0] Fer,Fei,For,Foi,Wr,Wi;
output[width-1:0] o0r,o0i,o1r,o1i;

wire[7:0] m0,m1,m2,m3,mr,mi;
// multiplication of complex numbers: m = Fo*W 
multiply #(.width(width),.decimal(decimal)) mp0(For,Wr,m0);
multiply #(.width(width),.decimal(decimal)) mp1(For,Wi,m1);
multiply #(.width(width),.decimal(decimal)) mp2(Foi,Wr,m2);
multiply #(.width(width),.decimal(decimal)) mp3(Foi,Wi,m3);

assign mr=m0-m3;
assign mi=m1+m2;

assign o0r=Fer+mr;
assign o0i=Fei+mi;

assign o1r=Fer-mr;
assign o1i=Fei-mi;

endmodule


module butterfly_freq(
f0r,	// Real part of input 0.
f0i,	// Imag part of input 0.
f1r,	// Real part of input 1.
f1i,	// Imag part of input 1.
Wr,		// Real part of the weight input.
Wi,		// Imag part of the weight input.
o0r,	// Real part of output 0.
o0i,	// Imag part of output 0.
o1r,	// Real part of output 1.
o1i		// Imag part of output 1.
    );

parameter width=8;
parameter decimal=4;

input[width-1:0] f0r,f0i,f1r,f1i,Wr,Wi;
output[width-1:0] o0r,o0i,o1r,o1i;

// Start of your code
assign o0r = f0r + f1r;
assign o0i = f0i + f1i;

wire[7:0]sub01r, sub01i;
// (X + jY) term in multiplication with W_Ni
assign sub01r = f0r - f1r;
assign sub01i = f0i - f1i;

// ****** Implementation of Eff. Complex Mult. ******
// (X + jY) (C + jS) = XC - YS (real), YC + XS (imag)
// G-H = (X + jY), sub01r = X, sub01i = Y
// W_Ni = (C + jS), Wr = C, Wi = S

wire[7:0] XC, YS, YC, XS; 
// multiplication of complex numbers: m = (G-H)*W 
multiply #(.width(width),.decimal(decimal)) mp0(sub01r, Wr ,XC);  
multiply #(.width(width),.decimal(decimal)) mp1(sub01i, Wi, YS);
multiply #(.width(width),.decimal(decimal)) mp2(sub01i, Wr, YC);
multiply #(.width(width),.decimal(decimal)) mp3(sub01r, Wi, XS);

assign o1r = XC - YS;
assign o1i = YC + XS;

// End of your code

endmodule
