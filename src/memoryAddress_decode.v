module memoryAddress_decode #(parameter LENGTH = 32)(
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
			if(D > 'h1000FFFF & D < 'h10020000)
				Q <= ((D - 'h10010000) >> 2);
			else if(D > 'h7F000000)
				Q <= 'h3F - (('h7FFFEFFC - D) >> 2);
			else
				Q <= ((D - 'h10010000) >> 2);
//				else
//					Q <= Q;
//	end

endmodule