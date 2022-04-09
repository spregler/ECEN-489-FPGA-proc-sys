`timescale 1ns / 1ps

module systolicarray_1(
clk,
rst,
mi0,
mi1,
mor
    );

parameter size=8;
parameter decimal=4;

input clk,rst;
input[4*size-1:0] mi0; // 32-bit
input[4*size-1:0] mi1; // 32-bit
output reg[4*size-1:0] mor;

wire[4*size-1:0] mo;

always@(posedge clk or negedge rst)begin
    if(~rst)begin
        mor<=0;
    end
    else begin
        mor<=mo;
    end
end
/* [width] [depth] */
wire[size-1:0] umi1[7:0];
wire[size-1:0] umi2[7:0];
wire[size-1:0] uai[7:0];
wire[size-1:0] uoutmi1[7:0];
wire[size-1:0] uoutmi2[7:0];
wire[size-1:0] uout[7:0];
wire[size-1:0] mul[7:0];

genvar gi;

generate
    for(gi=0;gi<8;gi=gi+1)begin : genu
        systolicarray_1_unit #(.size(size),.decimal(decimal)) ui(umi1[gi],umi2[gi],uai[gi],uoutmi1[gi],uoutmi2[gi],uout[gi]);
    end
endgenerate

//uout[0]
assign umi1[0] = mi0[size*4-1:size*3];
assign umi2[0] = mi1[size*4-1:size*3];
assign uai[0] = 8'b0;
assign uoutmi1[0] = umi1[0];
assign uoutmi2[0] = umi2[0];
multiply mul1(umi1[0],umi2[0],mul[0]);
assign uout[0] = uai[0] + mul[0];

//uout[1]
assign umi1[1] = mi0[size*2-1:size*1];
assign umi2[1] = uoutmi2[0];
assign uai[1] = 8'b0;
assign uoutmi1[1] = umi1[1];
assign uoutmi2[1] = umi2[1];
multiply mul2(umi1[1],umi2[1],mul[1]);
assign uout[1] = uai[1] + mul[1];

//uout[2]
assign umi1[2] = uoutmi1[0];
assign umi2[2] = mi1[size*3-1:size*2];
assign uai[2] = 8'b0;
assign uoutmi1[2] = umi1[2];
assign uoutmi2[2] = umi2[2];
multiply mul3(umi1[2],umi2[2],mul[2]);
assign uout[2] = uai[2] + mul[2];

//uout[3]
assign umi1[3] = uoutmi1[1];
assign umi2[3] = uoutmi2[2];
assign uai[3] = 8'b0;
assign uoutmi1[3] = umi1[3];
assign uoutmi2[3] = umi2[3];
multiply mul4(umi1[3],umi2[3],mul[3]);
assign uout[3] = uai[3] + mul[3];

//uout[4]
assign umi1[4] = mi0[size*3-1:size*2];
assign umi2[4] = mi1[size*2-1:size*1];
assign uai[4] = uout[0];
assign uoutmi1[4] = umi1[4];
assign uoutmi2[4] = umi2[4];
multiply mul5(umi1[4],umi2[4],mul[4]);
assign uout[4] = uai[4] + mul[4];

//uout[5]
assign umi1[5] = mi0[size*1-1:size*0];
assign umi2[5] = uoutmi2[4];
assign uai[5] = uout[1];
assign uoutmi1[5] = umi1[5];
assign uoutmi2[5] = umi2[5];
multiply mul6(umi1[5],umi2[5],mul[5]);
assign uout[5] = uai[5] + mul[5];

//uout[6]
assign umi1[6] = uoutmi1[4];
assign umi2[6] = mi1[size*1-1:size*0];
assign uai[6] = uout[2];
assign uoutmi1[6] = umi1[6];
assign uoutmi2[6] = umi2[6];
multiply mul7(umi1[6],umi2[6],mul[6]);
assign uout[6] = uai[6] + mul[6];

//uout[7]
assign umi1[7] = uoutmi1[5];
assign umi2[7] = uoutmi2[6];
assign uai[7] = uout[3];
assign uoutmi1[7] = umi1[7];
assign uoutmi2[7] = umi2[7];
multiply mul8(umi1[7],umi2[7],mul[7]);
assign uout[7] = uai[7] + mul[7];

assign mo[4*size-1:3*size] = uout[4];
assign mo[3*size-1:2*size] = uout[5];
assign mo[2*size-1:1*size] = uout[6];
assign mo[1*size-1:0*size] = uout[7];
endmodule
