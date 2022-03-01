`timescale 1ns / 1ps

module fft_time_tb(
Fr,Fi
    );

parameter width=8;
parameter decimal=4;

reg clk,rst;
reg [8*width-1:0] fr,fi;
output [8*width-1:0] Fr,Fi;

wire[width-1:0] fr_spilt[7:0];
wire[width-1:0] fi_spilt[7:0];
wire[width-1:0] Fr_spilt[7:0];
wire[width-1:0] Fi_spilt[7:0];

fft_time ft0(
clk,
rst,
fr,
fi,
Fr,
Fi
    );
    
initial begin
fr=64'h0bfcf1f4020f0d00; // Q(3,4) format of sin(7), sin(6), ... sin(1), sin(0).
fi=0;
clk=0;
rst = 0;
#4
rst = 1;
end

always #1 begin
    clk<=~clk;
end

genvar i;
generate
  for (i = 0; i < 8; i=i+1) begin:m
    assign fr_spilt[i] = fr[(i+1)*width-1:i*width];
    assign fi_spilt[i] = fi[(i+1)*width-1:i*width];
    assign Fr_spilt[i] = Fr[(i+1)*width-1:i*width];
    assign Fi_spilt[i] = Fi[(i+1)*width-1:i*width];
  end
endgenerate


endmodule
