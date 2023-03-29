//Shift register con carga
module Shift_Register_R_Param #(parameter width = 8)
    (
	 //Entradas y salidas del modulo
    input clk,
    input rst,
    input enable,
    input load,
    input [width-1:0] d,
    output reg [width-1:0] shifter,
	output reg Q
    );

always @(posedge rst, posedge clk)
	begin
		if (rst)
			Q <= {width{1'b0}};
		else
		//Si se requiere cargar
			if (load)
				shifter <= d;
			//Cuando se requiere desplazamiento
			else if (enable)
				shifter <= {1'b0,shifter[width-1:1]};
			else
				shifter <= shifter;
		//Se envia solo el ultimo bit
		Q <= shifter[0];
	end
endmodule
