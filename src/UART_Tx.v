module UART_Tx (
	input clk,enable,rst,
	input sw00,sw01,sw02,sw03,sw04,sw05,sw06,sw07,
	output tx,
	output UART_BUSY
);

	//FSM
	wire [7:0] Tx_Data_w;
	wire [2:0] sel;

	//BitRatePulse Wires
	wire rst_BitRatePulse_w;
	wire end_bit_time_w;
	
	//Para procesar el rst y enable
	wire enable_temp = enable;
	wire rst_temp = ~rst;
	
	//Salida del counter
	wire [2:0] Bit_index;
	
	//Salidas para tx
	wire tx_Start;
	wire tx_Stop;
	wire tx_Shifter;
	wire tx_Parity;
	
	//Enables
	wire enable_Counter;
	wire enable_ShiftRegister;
	wire enable_Parity;
	wire enable_Stop;
	wire enable_Start;
	wire enable_load;

	//Para guardar los valores de los switches
	wire [7:0] input_SW_reg;
	wire [7:0]input_SW;
	assign input_SW[0] = sw00;
	assign input_SW[1] = sw01;
	assign input_SW[2] = sw02;
	assign input_SW[3] = sw03;
	assign input_SW[4] = sw04;
	assign input_SW[5] = sw05;
	assign input_SW[6] = sw06;
	assign input_SW[7] = sw07;
	
	//counter
	wire rst_Counter_w;

	wire enableTxSend;

// For a baud rate of 9600 baudios: bit time 104.2 us, half time 52.1 us
// For a clock frequency of 50 MHz bit time = 5210 T50MHz;

Bit_Rate_Pulse # (.delay_counts(5210) ) BR_pulse (
	.clk(clk), 
	.rst(rst_BitRatePulse_w), 					
	.enable(1'b1), 
	.end_bit_time(end_bit_time_w)	
	);

//Para enviar el bit de start
register #(.LENGTH_v(1)) RegisterStart(
	.clock(clk),
	.reset(rst_temp),
	.enable(enable_Start),
	.D(1'b0),
	.Q(tx_Start)			
	);
//Para registrar los switches	
register #(.LENGTH_v(8)) RegisterSwitches(
	.clock(clk),
	.reset(rst_temp),
	.enable(enable),
	.D(input_SW),
	.Q(input_SW_reg)			
	);

//Para enviar el bit de stop
register #(.LENGTH_v(1)) RegisterStop(
	.clock(clk),
	.reset(rst_temp),
	.enable(enable_Stop),
	.D(1'b1),
	.Q(tx_Stop)			
	);

//Para enviar la trama de 8 bits
Shift_Register_R_Param #(.width(8)) Shifter(
	.clk(clk),
	.rst(rst_temp),					//This reset should come from FSM
	.load(enable_load),
	.enable(enable_ShiftRegister),
	.d(input_SW_reg),
	.Q(tx_Shifter)
	);

//Para enviar el bit de paridad	
parity #(.LENGTH(8)) paritybit(
	.clk(clk), 
	.rst(rst_temp), 
	.enable(enable_Parity),
	.tx_data(input_SW_reg),
	.parity_bit(tx_Parity)
);


//Para contar en que bit de la trama de datos nos encontramos
Counter_Param #(.n(3)) Counter(
	.clk(clk),
	.rst(rst_Counter_w),
	.enable(enable_Counter),
	.Q(Bit_index)
	);

//Elige que salida se enviara (stop, start, shifter, parity)
Mux_Tx Mux(
	.clk(clk),
	.rst(rst_temp),
	.enable(1'b1),
	.tx_Start(tx_Start),
	.tx_Stop(tx_Stop),
	.tx_Shifter(tx_Shifter),
	.tx_Parity(tx_Parity),
	.sel(sel),
	.tx(tx)
);

//FSM UART Tx
FSM_UART_Tx FSM_UART_Tx_TOP(
	.clk(clk),
	.n_rst(rst_temp),
	.tx_send(enable_temp),		//.tx_send(enable_temp),	
	.Bit_index(Bit_index),
	.end_bit_time(end_bit_time_w),		
	.rst_BitRatePulse(rst_BitRatePulse_w),
	.rst_Counter(rst_Counter_w),
	.enable_Counter(enable_Counter),
	.enable_ShiftRegister(enable_ShiftRegister),
	.enable_Parity(enable_Parity),
	.enable_Stop(enable_Stop),
	.enable_Start(enable_Start),
	.enable_load(enable_load),
	.UART_BUSY(UART_BUSY),
	.sel(sel)
	);

//Debouncer para evitar que se active mas de una vez consecutivamente la FSM
//Debouncer Debouncer_TOP(
//	.clk(clk),
//	.nrst(rst),
//	.sw(enable),
//	.one_shot(enableTxSend)
//	);

endmodule