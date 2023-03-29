//Modulo que nos da como resultado el bit de paridad par
module parity #(parameter LENGTH = 8) (
	input clk, rst, enable,
	input [LENGTH-1:0] tx_data,
	output reg parity_bit
    );

reg [3:0] ones = 3'b0;

always @(posedge clk, posedge rst)
begin
	if (rst)
		ones <= 0;
	else
		if (enable)
			begin
			//Cuenta cuantos unos tenemos en la trama de datos
					ones <= tx_data[0] + tx_data[1] + tx_data[2] + tx_data[3] + tx_data[4] + tx_data[5] + tx_data[6] + tx_data[7];
					//La salida nos dice si la cantidad de unos es par o impar (impar = 1 y par = 0)
					parity_bit <= ones[0] ? 1'b1 : 1'b0;
			end
		else
			ones <= ones;
end

endmodule