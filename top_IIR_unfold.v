`timescale 1ns / 1ps

module top_IIR_unfold(

    );

parameter LEN=300;
parameter LEN2=150;

wire clk;
wire memctl;

wire[15:0] memaddraxi;
wire[7:0] memdinaxi;
wire memwenaxi;

reg trigger;

//1st port, controlled by arm or fpga
wire[15:0] memaddra;
wire[15:0] memdina;
wire memwena;
wire[15:0] memdouta;

//2nd port, controlled by fpga
reg[15:0] memaddrb;
reg[15:0] memdinb;
reg memwenb;
wire[15:0] memdoutb;

//fpga controlled memory ports
reg[15:0] memaddrfpga;
reg[15:0] memdinfpga;
reg memwenfpga;

assign memaddra=memctl?memaddraxi:memaddrfpga;
assign memdina=memctl?{8'h0,memdinaxi}:memdinfpga;
assign memwena=memctl?memwenaxi:memwenfpga;

datatrans_sys_wrapper mw0
       (.axiclk(clk),
        .memaddr(memaddraxi),
        .memctl(memctl),
        .memdin(memdinaxi),
        .memdout(memdouta[7:0]),
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

reg[7:0] a,b,c,d;

reg[7:0] x2k,x2k1;
wire[7:0] y2k,y2k1;

IIR_unfold u0(
clk,
~memctl,
a,b,c,d,
x2k,x2k1,
y2k,y2k1
);

reg[7:0] i,j;

reg[7:0] state;

reg[15:0] count;

reg[7:0] shift;

reg[15:0] cycles;


always@(posedge clk)begin
	if(memctl)begin
	    state<=0;
	    count<=0;
	    shift<=0;
	    a<=0;
	    b<=0;
	    c<=0;
	    d<=0;
	    x2k<=0;
	    x2k1<=0;
	    trigger<=0;
	    cycles<=0;
	    
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
          memaddrb<=2000;
          memdinb<=0;
          count<=0;
          state<=state+1;
		end
		2:begin
		  if(count>=2)begin
		      if(shift==16)begin
		        if(memaddrb>=2000+LEN2-1)begin
                    state<=state+1;
                end
                else begin
                    memdinb<=memdouta;
                    memaddrb<=memaddrb+1;
                    shift<=8;
                end
		      end
		      else begin
		          memdinb<=memdinb|(memdouta<<shift);
		          shift<=shift+8;
		      end
		  end
		  memaddrfpga<=memaddrfpga+1;
		  count<=count+1;
		end
		3:begin
		  memwenfpga<=0;
          memaddrfpga<=2000;
          memdinfpga<=0;
          memwenb<=1;
          memaddrb<=3000;
          memdinb<=0;
          count<=0;
          shift<=0;
          state<=state+1;
		end
		4:begin
		  if(count>=2)begin
		    x2k<=memdouta[7:0];
		    x2k1<=memdouta[15:8];
		  end
		  if(count>=3)begin
		    memdinb[7:0]<=y2k;
		    memdinb[15:8]<=y2k1;
		  end
		  if(count>=4)begin
		    memaddrb<=memaddrb+1;
		  end
		  memaddrfpga<=memaddrfpga+1;
		  if(count<4)begin
		    count<=count+1;
		  end
		  if(memaddrb>=3000+LEN2-1)begin
		      state<=state+1;
		  end
		  cycles<=cycles+1;
		end
		5:begin
          memwenfpga<=0;
          memaddrfpga<=3000;
          memdinfpga<=0;
          memwenb<=1;
          memaddrb<=1000-1;
          memdinb<=0;
          count<=0;
          shift<=0;
          state<=state+1;
        end
        6:begin
          if(count>=2)begin
              if(shift==16)begin
                if(memaddrb>=1000+LEN)begin
                    state<=state+1;
                end
                else begin
                    count<=0;
                    memaddrfpga<=memaddrfpga+1;
                    shift<=0;
                end
              end
              else begin
                  memdinb<=((memdouta>>shift)&16'hff);
                  memaddrb<=memaddrb+1;
                  shift<=shift+8;
              end
          end
          else begin
             count<=count+1;
          end
        end
        7:begin
          memdinb<=cycles&16'h00ff;
          memaddrb<=1000+LEN;
          state<=state+1;
        end
        8:begin
          memdinb<=(cycles>>8)&16'h00ff;
          memaddrb<=1000+LEN+1;
          if(count==2)
          state<=state+1;
          count<=count+1;
        end
		9:begin
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