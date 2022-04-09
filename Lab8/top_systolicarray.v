`timescale 1ns / 1ps

module top_systolicarray(

    );

parameter size=8;
parameter decimal=4;

wire clk;
wire memctl;

wire[15:0] memaddraxi;
wire[7:0] memdinaxi;
wire memwenaxi;

reg trigger;

//1st port, controlled by arm or fpga
wire[15:0] memaddra;
wire[7:0] memdina;
wire memwena;
wire[7:0] memdouta;

//2nd port, controlled by fpga
reg[15:0] memaddrb;
reg[7:0] memdinb;
reg memwenb;
wire[7:0] memdoutb;

//fpga controlled memory ports
reg[15:0] memaddrfpga;
reg[7:0] memdinfpga;
reg memwenfpga;

assign memaddra=memctl?memaddraxi:memaddrfpga;
assign memdina=memctl?memdinaxi:memdinfpga;
assign memwena=memctl?memwenaxi:memwenfpga;

datatrans_sys_wrapper mw0
       (.axiclk(clk),
        .memaddr(memaddraxi),
        .memctl(memctl),
        .memdin(memdinaxi),
        .memdout(memdouta),
        .memwen(memwenaxi),
        .triggerin(trigger));

blk_mem_gen_0 b0
  (
      clk,
      memwena,
      memaddra,
      memdina,
      memdouta,
      clk,
      memwenb,
      memaddrb,
      memdinb,
      memdoutb
  );

reg srst;
reg[4*size-1:0] mi0;
reg[4*size-1:0] mi1;
wire[4*size-1:0] mo;

systolicarray_2 #(.size(size),.decimal(decimal)) s2(clk,srst,mi0,mi1,mo);

reg[7:0] state;

reg[7:0] ite;

reg[15:0] count;

always@(posedge clk)begin
    if(memctl)begin
        state<=0;
        trigger<=0;
        count<=0;
        
        memwenfpga<=0;
        memaddrfpga<=0;
        memdinfpga<=0;
        
        memwenb<=0;
        memaddrb<=0;
        memdinb<=0;
        
        srst<=0;
        ite<=0;
        mi0<=0;
        mi1<=0;
    end
    else begin
        case(state)
        0:begin
            srst<=0;
            mi0<=0;
            mi1<=0;
            memwenfpga<=0;
            memaddrfpga<=0;
            memdinfpga<=0;
            memwenb<=0;
            memaddrb<=8*ite;
            memdinb<=0;
            count<=0;
            state<=state+1;
        end
        1:begin
            if(count>=2&&count<6)begin
                mi0<=mi0|(memdoutb<<(8*(count-2)));
            end
            else if(count>=6&&count<10)begin
                mi1<=mi1|(memdoutb<<(8*(count-6)));
            end
            else if(count==10)begin
                state<=state+1;
            end
            memaddrb<=memaddrb+1;
            count<=count+1;
        end
        2:begin
            srst<=1;
            count<=0;
            state<=state+1;;
        end
        3:begin
            if(count>=5)begin
                state<=state+1;
            end
            else
            count<=count+1;
        end
        4:begin
          memwenfpga<=0;
          memaddrfpga<=0;
          memdinfpga<=0;
          memwenb<=1;
          memaddrb<=100*(ite+1)-1;
          memdinb<=0;
          count<=0;
          state<=state+1;
        end
        5:begin
          if(count<4)begin
            memdinb<=mo>>(count*8);
            memaddrb<=memaddrb+1;
            count<=count+1;
          end
          else begin
            if(ite==2)
            state<=state+1;
            else begin
                ite<=ite+1;
                state<=0;
            end
          end
        end
        6:begin
            memwenfpga<=0;
            memaddrfpga<=0;
            memdinfpga<=0;
            memwenb<=0;
            memaddrb<=0;
            memdinb<=0;
            trigger<=1;
        end
        endcase
    end
end

endmodule
