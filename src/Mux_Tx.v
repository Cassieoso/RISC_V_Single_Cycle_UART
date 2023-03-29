module Mux_Tx (
//Multiplexor que elige que es lo que se vera en la salida tx
//Entradas y salidas del multiplexor
input clk, rst, enable,
input tx_Start, tx_Stop, tx_Shifter, tx_Parity,
input [2:0] sel,
output reg tx
);

//En que estado nos encontramos para decidir la salida
localparam START = 2'b00;
localparam STOP = 2'b01;
localparam PARITY = 2'b10;
localparam SHIFTER = 2'b11;

always @(posedge clk, posedge rst)
begin
	if (rst)
		tx <= 1'b0;
	else
		if (enable)
			case (sel)
			//Envia a tx el valor correspondiente al estado de la FSM en que se encuentra
			START: tx <= tx_Start;
			STOP: tx <= tx_Stop;
			PARITY: tx <= tx_Parity;
			SHIFTER: tx <= tx_Shifter;
			
			endcase
		else
			tx <= tx;			
end
endmodule