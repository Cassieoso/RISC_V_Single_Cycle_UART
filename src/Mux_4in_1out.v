module Mux_4in_1out #(parameter LENGTH = 32)(
//Multiplexor que elige que es lo que se vera en la salida tx
//Entradas y salidas del multiplexor
input clk, rst, enable,
input [LENGTH-1:0]A, B, C, D,
input [1:0] sel,
output reg [LENGTH-1:0]Q
);

//En que estado nos encontramos para decidir la salida
localparam A_TO_OUT = 2'b00;
localparam B_TO_OUT = 2'b01;
localparam C_TO_OUT = 2'b10;
localparam D_TO_OUT = 2'b11;

always @*
begin
//	if (rst)
//		Q <= {LENGTH{1'b0}};
//	else
//		if (enable)
			case (sel)
			A_TO_OUT: Q <= A;
			B_TO_OUT: Q <= B;
			C_TO_OUT: Q <= C;
			D_TO_OUT: Q <= D;
			endcase
//		else
//			Q <= Q;			
end
endmodule