module programCounter #(parameter LENGTH = 32)(
	input clock,reset,enable,
	input [LENGTH-1:0]D,
	output reg [LENGTH-1:0]Q
	);

initial 
	begin
		Q <= 'h400000;
	end
	
always @(posedge clock, posedge reset) 
	begin
		if(reset) 
            Q <= 'h400000;
        else
			if(enable)
				Q <= D;
				else
					Q <= Q;
	end

endmodule