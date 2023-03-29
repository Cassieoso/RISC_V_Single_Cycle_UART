module RISC_V_tb ();
reg clk, reset;

RISC_V #(.LENGTH(32)) UUT(.clock(clk), .reset(reset));

initial
	begin
		clk = 1'b1;
		reset = 1'b1;
		#10 reset = 1'b0;
	end
	
always
	begin
	#10 clk = ~clk;
	end
	
endmodule
