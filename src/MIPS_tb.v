module MIPS_tb ();
reg clk, reset;

MIPS #(.LENGTH(32)) UUT(.clock(clk), .reset(reset));

initial
	begin
		clk = 1'b0;
		reset = 1'b0;
	end
	
always
	begin
	#10 clk = ~clk;
	end
	
endmodule
