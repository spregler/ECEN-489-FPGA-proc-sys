`timescale 1ns / 1ps

module systolicarray_2(
clk,
rst,
mi0,
mi1,
mo
    );

parameter size=8;
parameter decimal=4;

input clk,rst;
input[4*size-1:0] mi0;
input[4*size-1:0] mi1;
output[4*size-1:0] mo;

/* [width] [depth] */
reg[size-1:0] umi1[3:0];
reg[size-1:0] umi2[3:0];
/* Wires to use in instantiation */
wire[size-1:0] wmi1[3:0];
wire[size-1:0] wmi2[3:0];
wire[size-1:0] uoutmi1[3:0];
wire[size-1:0] uoutmi2[3:0];
wire[size-1:0] uout[3:0];

reg [3:0]cnt; // FSM state
reg outReady;
reg[size-1:0] outreg[3:0]; // Output register for syncing correct values to output port

systolicarray_2_unit PE0(clk, rst, wmi1[0], wmi2[0], uoutmi1[0], uoutmi2[0], uout[0]);
systolicarray_2_unit PE1(clk, rst, wmi1[1], wmi2[1], uoutmi1[1], uoutmi2[1], uout[1]);
systolicarray_2_unit PE2(clk, rst, wmi1[2], wmi2[2], uoutmi1[2], uoutmi2[2], uout[2]);
systolicarray_2_unit PE3(clk, rst, wmi1[3], wmi2[3], uoutmi1[3], uoutmi2[3], uout[3]);
/* assign output port to output register */
assign mo[4*size-1:3*size] = outreg[3];
assign mo[3*size-1:2*size] = outreg[2];
assign mo[2*size-1:1*size] = outreg[1];
assign mo[1*size-1:0*size] = outreg[0];
/* wire the PE inputs. Notice the first two */
assign wmi1[3] = uoutmi1[1];
assign wmi1[2] = uoutmi1[0];
assign wmi1[1] = umi1[1];
assign wmi1[0] = umi1[0];

assign wmi2[3] = uoutmi2[2];
assign wmi2[2] = umi2[2];
assign wmi2[1] = uoutmi2[0];
assign wmi2[0] = umi2[0];

integer i;
always@(posedge clk or negedge rst)begin
    if(~rst)begin
        // Start of your code.
        cnt <= 0;
        outReady <= 0;
        umi1[0] <= 8'b0000_0000;
        umi1[1] <= 8'b0000_0000;
        umi1[2] <= 8'b0000_0000;
        umi1[3] <= 8'b0000_0000;
        umi2[0] <= 8'b0000_0000;
        umi2[1] <= 8'b0000_0000;
        umi2[2] <= 8'b0000_0000;
        umi2[3] <= 8'b0000_0000;
        // End of your code.
    end
    else begin
        // Start of your code.
        case(cnt)
            0: begin
                umi1[0] <= mi0[1*size-1:0*size]; // Load a11 into PE0
                umi2[0] <= mi1[1*size-1:0*size]; // Load b11 into PE0
                cnt <= 1;
            end
            1: begin
                outreg[0] <= uout[0];
                umi1[0] <= mi0[2*size-1:1*size]; // Load a12 into PE0
                umi2[0] <= mi1[3*size-1:2*size]; // Load b21 into PE0
                umi1[1] <= mi0[3*size-1:2*size]; // Load a21 into PE1
                umi2[2] <= mi1[2*size-1:1*size]; // Load b12 into PE2
                cnt <= 2;
            end
            2: begin
                outreg[0] <= uout[0];
                outreg[1] <= uout[1];
                outreg[2] <= uout[2];
                umi1[1] <= mi0[4*size-1:3*size]; // Load a22 into PE1
                umi2[2] <= mi1[4*size-1:3*size]; // Load b22 into PE2
                cnt <= 3;
            end
            3: begin
                outreg[0] <= uout[0];
                outreg[2] <= uout[1];
                outreg[1] <= uout[2];
                cnt <= 4;
            end
            4: begin
                outreg[2] <= uout[1];
                outreg[1] <= uout[2];
                outReady <= 1;
                cnt <= 5;
            end
            5: begin
                if (outReady) begin outreg[3] <= uout[3]; end
                outReady <= 0; // Computation finish, stop changing output.
            end
        endcase
        // End of your code.
    end
end

endmodule
