`timescale 1ns / 1ps

module fft_freq_pipe_tb(
Fr,Fi
    );

parameter width=8;
parameter decimal=4;

reg clk,rst;

reg [8*width-1:0] fr,fi;
output [8*width-1:0] Fr,Fi;

wire[width-1:0] Fr_spilt[7:0];
wire[width-1:0] Fi_spilt[7:0];

fft_freq_pipe f0(
clk,
rst,
fr,
fi,
Fr,
Fi
    );

initial begin
fr=64'h0000000000000000;
fi=0;
clk=0;
rst=0;
#4 rst=1;
fr=64'h0bfcf1f4020f0d00;		 // Inputs of the 1st stage
#2 fr = 64'h0000000010101010;	 // Inputs of the 2nd stage
#2 fr = 64'h04080c100c080400;	 // Inputs of the 3rd stage
end

always #1 begin
    clk<=~clk;
end

genvar i;
generate
  for (i = 0; i < 8; i=i+1) begin:m
    assign Fr_spilt[i] = Fr[(i+1)*width-1:i*width];
    assign Fi_spilt[i] = Fi[(i+1)*width-1:i*width];
  end
endgenerate


endmodule
