`timescale 1ns / 1ps

module fft_time(
clk,
rst,
fr,     // Real part of the 8 inputs.
fi,     // Imag part of the 8 inputs.
Fr,     // Real part of the 8 outputs.
Fi      // Imag part of the 8 outputs.
    );

parameter width=8;
parameter decimal=4;

input clk,rst;

//fr: the real part of input
//fi: the imag part of input
//inputReal[i]=fr[(i+1)*width-1:i*width]
//inputImag[i]=fi[(i+1)*width-1:i*width]
input [8*width-1:0] fr,fi;

//Fr: the real part of output
//Fi: the imag part of output
//outputReal[i]=Fr[(i+1)*width-1:i*width]
//outputImag[i]=Fi[(i+1)*width-1:i*width]
output reg [8*width-1:0] Fr,Fi;

// Wires for the outputs.
wire[8*width-1:0] Fwr,Fwi;

// Outputs of level 3
wire[width-1:0] o0r[7:0];
wire[width-1:0] o0i[7:0];

// Outputs of level 2
wire[width-1:0] o1r[7:0];
wire[width-1:0] o1i[7:0];

//-----------------------------level 3---------------------------//
butterfly_time #(.width(width),.decimal(decimal)) bt0(fr[1*width-1:0*width],fi[1*width-1:0*width],fr[5*width-1:4*width],fi[5*width-1:4*width],(1<<decimal),0,o0r[0],o0i[0],o0r[1],o0i[1]);
butterfly_time #(.width(width),.decimal(decimal)) bt1(fr[3*width-1:2*width],fi[3*width-1:2*width],fr[7*width-1:6*width],fi[7*width-1:6*width],(1<<decimal),0,o0r[2],o0i[2],o0r[3],o0i[3]);
butterfly_time #(.width(width),.decimal(decimal)) bt2(fr[2*width-1:1*width],fi[2*width-1:1*width],fr[6*width-1:5*width],fi[6*width-1:5*width],(1<<decimal),0,o0r[4],o0i[4],o0r[5],o0i[5]);
butterfly_time #(.width(width),.decimal(decimal)) bt3(fr[4*width-1:3*width],fi[4*width-1:3*width],fr[8*width-1:7*width],fi[8*width-1:7*width],(1<<decimal),0,o0r[6],o0i[6],o0r[7],o0i[7]);

//-----------------------------level 2---------------------------//
butterfly_time #(.width(width),.decimal(decimal)) bt4(o0r[0],o0i[0],o0r[2],o0i[2],(1<<decimal),0,o1r[0],o1i[0],o1r[2],o1i[2]);
butterfly_time #(.width(width),.decimal(decimal)) bt5(o0r[1],o0i[1],o0r[3],o0i[3],0,-16,o1r[1],o1i[1],o1r[3],o1i[3]);
butterfly_time #(.width(width),.decimal(decimal)) bt6(o0r[4],o0i[4],o0r[6],o0i[6],(1<<decimal),0,o1r[4],o1i[4],o1r[6],o1i[6]);
butterfly_time #(.width(width),.decimal(decimal)) bt7(o0r[5],o0i[5],o0r[7],o0i[7],0,-16,o1r[5],o1i[5],o1r[7],o1i[7]);

//-----------------------------level 1---------------------------//
butterfly_time #(.width(width),.decimal(decimal)) bt8(o1r[0],o1i[0],o1r[4],o1i[4],(1<<decimal),0,Fwr[1*width-1:0*width],Fwi[1*width-1:0*width],Fwr[5*width-1:4*width],Fwi[5*width-1:4*width]);
butterfly_time #(.width(width),.decimal(decimal)) bt9(o1r[1],o1i[1],o1r[5],o1i[5],11,-11,Fwr[2*width-1:1*width],Fwi[2*width-1:1*width],Fwr[6*width-1:5*width],Fwi[6*width-1:5*width]);
butterfly_time #(.width(width),.decimal(decimal)) bt10(o1r[2],o1i[2],o1r[6],o1i[6],0,-16,Fwr[3*width-1:2*width],Fwi[3*width-1:2*width],Fwr[7*width-1:6*width],Fwi[7*width-1:6*width]);
butterfly_time #(.width(width),.decimal(decimal)) bt11(o1r[3],o1i[3],o1r[7],o1i[7],-11,-11,Fwr[4*width-1:3*width],Fwi[4*width-1:3*width],Fwr[8*width-1:7*width],Fwi[8*width-1:7*width]);


always@(posedge clk or negedge rst)begin
    if(~rst)begin
        Fr<=0;
        Fi<=0;
    end
    else begin
        Fr<=Fwr;
        Fi<=Fwi;
    end
end

endmodule
