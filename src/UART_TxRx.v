module UART_TxRx (
	input clock, reset,
	//UART_Rx
	input rx,
	output parity,
	output [8:0]Rx_SR,
	output heard_bit_out,
	output [6:0] HEX0,
	output [6:0] HEX2,
	output [6:0] HEX3,
	//UART_Tx
	input sendTx,
	input sw00,sw01,sw02,sw03,sw04,sw05,sw06,sw07,
	input reset_UART_READY,
	output tx, UART_BUSY, enable_out_rx
	);

//UART Rx  TOP module 
UART_Rx UART_Rx_TOP(
	.clk(clock),
	.n_rst(reset),
	.reset_UART_READY(reset_UART_READY),
	.rx(rx),
	.parity(parity),
	.Rx_SR(Rx_SR),
	.heard_bit_out(heard_bit_out),
	.HEX0(HEX0),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.enable_out_rx(enable_out_rx)
	);

//UART Tx TOP module 
UART_Tx UART_Tx_TOP(
	.clk(clock),
	.enable(sendTx),
	.rst(1),
	.sw00(sw00),
	.sw01(sw01),
	.sw02(sw02),
	.sw03(sw03),
	.sw04(sw04),
	.sw05(sw05),
	.sw06(sw06),
	.sw07(sw07),
	.tx(tx),
	.UART_BUSY(UART_BUSY)
	);

	
endmodule