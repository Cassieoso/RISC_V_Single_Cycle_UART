module programCounter_decode #(parameter LENGTH = 32)(
	input clock,reset,enable,
	input [LENGTH-1:0]D,
	output reg [LENGTH-1:0]Q
	);

initial 
	begin
		Q <= 32'h00000000;
	end
	
always @*
//	begin
//		if(reset) 
//            Q <= 32'h00000000;
//        else
//			if(enable)
				Q <= (D - 'h400000) >> 2;
//				else
//					Q <= Q;
//	end

endmodule