module Mux_2in_1out #(parameter LENGTH = 32)(
    //Multiplexor que elige que es lo que se vera en la salida tx
    //Entradas y salidas del multiplexor
    input clk, rst, enable,
    input [LENGTH-1:0]A, 
    input [LENGTH-1:0]B,
    input sel,
    output reg [LENGTH-1:0]Q
    );

//En que estado nos encontramos para decidir la salida
localparam A_TO_OUT = 1'b0;
localparam B_TO_OUT = 1'b1;


always @*
begin
//	if (rst)
//		Q <= {LENGTH{1'b0}};
//	else
//		if (enable)
			case (sel)
			//Envia a tx el valor correspondiente al estado de la FSM en que se encuentra
			A_TO_OUT: Q <= A;
			B_TO_OUT: Q <= B;
			default: Q <= Q;
			endcase
//		else
//			Q <= Q;			
end
endmodule