module Adder_param #(parameter LENGTH = 32)(
	input [LENGTH-1:0]A,
	input [LENGTH-1:0]B,
	output reg [LENGTH-1:0]Q
	);

initial 
	begin
		Q <= 32'h00000000;
	end
	
always @*
				Q <= A + B;
endmodule