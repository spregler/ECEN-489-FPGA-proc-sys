`timescale 1ns / 1ps

module fft_freq_pipe(
clk,
rst,
fr,
fi,
Fr,
Fi
    );

parameter width=8;
parameter decimal=4;

input clk,rst;

input [8*width-1:0] fr,fi;
output reg[8*width-1:0] Fr,Fi;

wire[width-1:0] o0r[7:0];
wire[width-1:0] o0i[7:0];

// Registered outputs of level 1
reg[width-1:0] r0r[7:0];
reg[width-1:0] r0i[7:0];

wire[width-1:0] o1r[7:0];
wire[width-1:0] o1i[7:0];

// Registered outputs of level 2
reg[width-1:0] r1r[7:0];
reg[width-1:0] r1i[7:0];

wire [8*width-1:0] Fwr,Fwi;


// Start of your code
//-----------------------------level 1---------------------------//




//-----------------------------level 2---------------------------//





//-----------------------------level 3---------------------------//







// End of your code


endmodule
