`timescale 1ns / 1ps

module top_fft_time(

    );

parameter width=8;
parameter decimal=4;
parameter fftn=8;
parameter signal=3;

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

reg [8*width-1:0] fr,fi;
wire [8*width-1:0] Fr,Fi;

fft_time #(.width(width),.decimal(decimal)) ft0(
clk,
~memctl,
fr,
fi,
Fr,
Fi
    );

reg[7:0] i,j;

reg[7:0] state;

reg[15:0] count;

reg[7:0] fftc,shift;

always@(posedge clk)begin
	if(memctl)begin
	    state<=0;
	    count<=0;
	    trigger<=0;
	    shift<=0;
	    
	    fr<=0;
	    fi<=0;
	    fftc<=0;
	    
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
		    if(count&1)begin
		      fi<=fi|(memdouta<<shift);
		      shift<=shift+8;
		      if(count>=fftn*2-1+2)begin
		          count<=0;
		          state<=state+1;
		      end
		    end
		    else begin
		      fr<=fr|(memdouta<<shift);
		    end
		  end
		  count<=count+1;
		  memwenb<=0;
          memaddrfpga<=memaddrfpga+1;
		end
		1:begin
		  if(count>=100)begin
		      count<=0;
		      shift<=0;
		      state<=state+1;
		  end
		  else
		  count<=count+1;
		end
		2:begin
		  memwenfpga<=0;
          memaddrfpga<=0;
          memdinfpga<=0;
          memwenb<=1;
          memaddrb<=100+fftn*fftc*2;
          memdinb<=0;
          state<=state+1;
		end
		3:begin
		  if(count&1)begin
		      memdinb<=(Fi>>shift)&'hff;
		      shift<=shift+8;
		      if(count>=fftn*2-1)begin
		          count<=0;
		          state<=state+1;
		      end
		  end
		  else begin
		      memdinb<=(Fr>>shift)&'hff;
		  end
		  count<=count+1;
		  if(count>0)
		  memaddrb<=memaddrb+1;
		end
		4:begin
          if(count>=2)begin
              count<=0;
              shift<=0;
              fftc<=fftc+1;
              state<=state+1;
          end
          else
          count<=count+1;
        end
		5:begin
          memwenfpga<=0;
          memaddrfpga<=fftn*fftc*2;
          memdinfpga<=0;
          memwenb<=0;
          memaddrb<=fftn*fftc*2;
          memdinb<=0;
          fr<=0;
          fi<=0;
          if(fftc>=signal)
          state<=state+1;
          else
          state<=0;
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
