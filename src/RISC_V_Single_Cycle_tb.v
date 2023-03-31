module RISC_V_Single_Cycle_tb ();
reg clk, reset;
wire [7:0] gpio_port_out;
reg [7:0] gpio_port_in;
wire tx;
reg rx;

RISC_V_Single_Cycle UUT(.clk(clk), .reset(reset), .gpio_port_out(gpio_port_out), .gpio_port_in(gpio_port_in), .tx(tx), .rx(rx));

initial
	begin
		clk = 1'b1;
		gpio_port_in = 7'b0000101;
		rx = 1'b1;
		reset = 1'b1;
		#10 reset = 1'b0;
		#70 rx = 1'b0;
		#104200 rx = 1'b1;
		#104200 rx = 1'b1;
		#104200 rx = 1'b0;
		#104200 rx = 1'b0;
		#104200 rx = 1'b0;
		#104200 rx = 1'b0;
		#104200 rx = 1'b0;
		#104200 rx = 1'b0;
		#104200 rx = 1'b1;
	end
	
always
	begin
	#10 clk = ~clk;
	end
	
//always
//	begin
//		#104200 rx = 1'b1;
//		#104200 rx = 1'b0;
//	end	

endmodule
