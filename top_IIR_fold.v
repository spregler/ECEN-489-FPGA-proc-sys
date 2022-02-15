`timescale 1ns / 1ps

module top_IIR_fold(

    );

parameter order_in=0;
parameter order_out=0;

parameter LEN=300;

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

blk_mem_gen_1 b0
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

reg[7:0] x;
wire[7:0] y;
reg[7:0] a,b,c,d;
reg rst;

IIR_fold i0(
clk,
~memctl,
a,b,c,d,
x,
y
);

reg[7:0] i,j;

reg[7:0] state;

reg[15:0] count;

reg[7:0] order;

reg[15:0] cycles;

always@(posedge clk)begin
	if(memctl)begin
	    state<=0;
	    count<=0;
	    a<=0;
	    b<=0;
	    c<=0;
	    d<=0;
	    x<=0;
	    trigger<=0;
	    cycles<=0;
	    order<=0;
	    
	    memwenfpga<=0;
	    memaddrfpga<=0;
	    memdinfpga<=0;
	    
	    memwenb<=0;
	    memaddrb<=0;
	    memdinb<=0;
	end 
	else begin
		case(state)
		0:begin
		  if(count>=2)begin
		    case(count)
		    2:begin
		      a<=memdoutb;
		    end
		    3:begin
		      b<=memdoutb;
		    end
		    4:begin
		      c<=memdoutb;
		    end
		    5:begin
		      d<=memdoutb;
		      state<=state+1;
		    end
		    endcase
		  end
		  count<=count+1;
		  memwenb<=0;
          memaddrb<=memaddrb+1;
		end
		1:begin
		  memwenfpga<=0;
          memaddrfpga<=4;
          memdinfpga<=0;
		  memwenb<=1;
          memaddrb<=2000-1;
          memdinb<=0;
          count<=0;
          order<=0;
          state<=state+1;
		end
		2:begin
		  if(count>=2)begin
		      state=state+1;
		      count<=0;
		  end
		  else
		  count<=count+1;
		end
		3:begin
		  cycles<=cycles+1;
		  if(order==3)
		  order<=0;
		  else
		  order<=order+1;
		  if((order==order_in))begin
		      if(count<3)
		      count<=count+1;
		      x<=memdouta;
		      memaddrfpga<=memaddrfpga+1;
		  end
		  if((order==order_out+2)||(order==0&&order_in==2)||(order==1&&order_in==3))begin
		      if(count==3)begin
                  memdinb<=y;
                  memaddrb<=memaddrb+1;
		      end
		  end
		  if(memaddrb>=2000+LEN)begin
		      state<=state+1;
		  end
		end
		4:begin
          memdinb<=cycles&16'h00ff;
          memaddrb<=2000+LEN;
          state<=state+1;
        end
        5:begin
          memdinb<=(cycles>>8)&16'h00ff;
          memaddrb<=2000+LEN+1;
          if(count==2)
          state<=state+1;
          count<=count+1;
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
