module FSM_UART_Tx (
//Entradas y salidas de la FSM
input clk, n_rst, tx_send, end_bit_time,
input [2:0] Bit_index,
output reg rst_BitRatePulse, rst_Counter, enable_Counter, enable_ShiftRegister, enable_Parity, enable_Stop, enable_Start, enable_load, UART_BUSY,
output reg [2:0] sel
);

//Estados de la FSM
parameter s_IDLE         = 3'b000;
parameter s_TX_START_BIT = 3'b001;
parameter s_TX_DATA_BIT_PROCESSING = 3'b010;
parameter s_ADD_BIT_INDEX = 3'b011;
parameter s_TX_PARITY_BIT  = 3'b100;
parameter s_TX_STOP_BIT  = 3'b101;
parameter s_DONE      = 3'b110;

reg [2:0] Tx_state = 3'b000;

//Funcionamiento de la maquina de estados
always@ (posedge clk, posedge n_rst)
begin
	if (n_rst)
		Tx_state <= s_IDLE;
	else
	case (Tx_state)
		//Aqui estara esperando a que le lleguen datos
		s_IDLE: 
			if (tx_send)
				Tx_state <= s_TX_START_BIT;
		//Empieza a enviar datos
		s_TX_START_BIT:
			if (end_bit_time)
				Tx_state <= s_TX_DATA_BIT_PROCESSING;
		//Hace shift de la trama de datos	
		s_TX_DATA_BIT_PROCESSING:
			if (end_bit_time)
				if (Bit_index < 7)
					Tx_state <= s_ADD_BIT_INDEX;
				else
					Tx_state <= s_TX_PARITY_BIT;
			else
				Tx_state <= s_TX_DATA_BIT_PROCESSING;
		//Envia el siguiente bit		
		s_ADD_BIT_INDEX:
			Tx_state <= s_TX_DATA_BIT_PROCESSING;
		//Envia el bit de paridad
		s_TX_PARITY_BIT:
			if (end_bit_time)
				Tx_state <= s_TX_STOP_BIT;
		//Envia el stop
		s_TX_STOP_BIT:
			if (end_bit_time)
				Tx_state <= s_DONE;
		//Pone todo en modo default
		s_DONE:
			Tx_state <= s_IDLE;
		default:
			Tx_state <= s_IDLE;
	endcase
		
end

//Que es lo que habilita cada estado
always @(Tx_state)
begin
	case (Tx_state)
		s_IDLE: 
			begin
			rst_BitRatePulse = 1'b1;
			rst_Counter = 1'b1;
			enable_Counter = 1'b0;
			enable_ShiftRegister = 1'b0;
			enable_Parity = 1'b0;
			enable_Stop = 1'b1;
			enable_Start = 1'b0;
			sel = 2'b01;
			enable_load = 1'b0;
			UART_BUSY = 1'b0;
			end
		
		s_TX_START_BIT:
			begin
			rst_BitRatePulse = 1'b0;
			rst_Counter = 1'b0;
			enable_Counter = 1'b0;
			enable_ShiftRegister = 1'b0;
			enable_Parity = 1'b0;
			enable_Stop = 1'b0;
			enable_Start = 1'b1;
			sel = 2'b00;
			enable_load = 1'b1;
			UART_BUSY = 1'b1;
			end		
			
		s_TX_DATA_BIT_PROCESSING:
			begin
			rst_BitRatePulse = 1'b0;
			rst_Counter = 1'b0;
			enable_Counter = 1'b0;
			enable_ShiftRegister = 1'b0;
			enable_Parity = 1'b0;
			enable_Stop = 1'b0;
			enable_Start = 1'b0;
			sel = 2'b11;
			enable_load = 1'b0;
			UART_BUSY = 1'b1;
			end
			
		s_ADD_BIT_INDEX:
			begin
			rst_BitRatePulse = 1'b0;
			rst_Counter = 1'b0;
			enable_Counter = 1'b1;
			enable_ShiftRegister = 1'b1;
			enable_Parity = 1'b0;
			enable_Stop = 1'b0;
			enable_Start = 1'b0;
			sel = 2'b11;
			enable_load = 1'b0;
			UART_BUSY = 1'b1;
			end

		s_TX_PARITY_BIT:
			begin
			rst_BitRatePulse = 1'b0;
			rst_Counter = 1'b1;
			enable_Counter = 1'b0;
			enable_ShiftRegister = 1'b0;
			enable_Parity = 1'b1;
			enable_Stop = 1'b0;
			enable_Start = 1'b0;
			sel = 2'b10;
			enable_load = 1'b0;
			UART_BUSY = 1'b1;
			end

		s_TX_STOP_BIT:
			begin
			rst_BitRatePulse = 1'b0;
			rst_Counter = 1'b0;
			enable_Counter = 1'b0;
			enable_ShiftRegister = 1'b0;
			enable_Parity = 1'b0;
			enable_Stop = 1'b1;
			enable_Start = 1'b0;
			sel = 2'b01;
			enable_load = 1'b0;
			UART_BUSY = 1'b1;
			end
			
		s_DONE:
			begin
			rst_BitRatePulse = 1'b0;
			rst_Counter = 1'b0;
			enable_Counter = 1'b0;
			enable_ShiftRegister = 1'b0;
			enable_Parity = 1'b0;
			enable_Stop = 1'b0;
			enable_Start = 1'b0;
			sel = 2'b01;
			enable_load = 1'b0;
			UART_BUSY = 1'b0;
			end
	endcase
end
endmodule