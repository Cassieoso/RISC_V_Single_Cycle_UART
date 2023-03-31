module PCH (
    input clk, reset, MemWrite,
	 input [31:0] HADDR,
	 input [31:0] HRDATA_IN_GPIO, HRDATA_IN_INSTR_MEMORY, HRDATA_IN_DATA_MEMORY,
	 input [7:0] HRDATA_IN_UART,
	 input [31:0] HWDATA_IN,
	 input HRDATA_IN_UART_BUSY, HRDATA_IN_UART_READY,
	 output reg enable_LEDS, enable_SWITCHES, enable_MemWrite, enable_SendTx, reset_UART_READY,
//	 output reg enable_WRITE,
    output reg [31:0] HRDATA_OUT_Instr,HRDATA_OUT_Data, HWDATA_OUT
    );

	 
	 

//localparam LEDS = 'h10010024;
//localparam SWITCHES = 'h10010028;
localparam DATA_MEMORY			= 3'b000;
localparam LEDS					= 3'b001;
localparam SWITCHES				= 3'b010;
localparam INSTR_MEMORY			= 3'b011;
localparam UART_TX				= 3'b100;
localparam UART_RX				= 3'b101;
localparam UART_BUSY				= 3'b110; //Para ver si aun sigue mandando los bits del Tx
localparam UART_READY			= 3'b111; //Para ver si ya nos llego algo del Rx
//reg [31:0] HWDATA_UART_TX;


reg [2:0] pheripherals;

always @*
	begin
		if(HADDR == 'h10010024)
			pheripherals = 3'b001;
		else if(HADDR == 'h10010028)
			pheripherals = 3'b010;
		else if(HADDR == 'h1001002C)			//Direccion de la UART_TX, en realidad es la direccion 0x1001002C pero esta decodificada
			pheripherals = 3'b100;
		else if(HADDR == 'h10010030)			//Direccion de la UART_RX, en realidad es la direccion 0x10010030 pero esta decodificada
			pheripherals = 3'b101;
		else if(HADDR == 'h10010034)			//Direccion de la UART_BUSY, en realidad es la direccion 0x10010034 pero esta decodificada
			pheripherals = 3'b110;
		else if(HADDR == 'h10010038)			//Direccion de la UART_READY, en realidad es la direccion 0x10010038 pero esta decodificada
			pheripherals = 3'b111;
		else if(HADDR > 'h1000FFFF)			//Direccion de la memoria de datos
			pheripherals = 3'b000;
		else
			pheripherals = 3'b011;
	end
	

always@*
    begin
		if(reset)
			begin
            HRDATA_OUT_Instr <= 32'b0;
				HRDATA_OUT_Data <= 32'b0;
				reset_UART_READY	= 1'b1;
			end
        else
			case(pheripherals)
				LEDS:
				begin
					enable_LEDS 		= 1'b1;
					enable_SWITCHES 	= 1'b0;
					enable_MemWrite	= MemWrite;
					enable_SendTx		=	1'b0;
					reset_UART_READY	= 1'b0;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = 'h0;
					HWDATA_OUT = HWDATA_IN;
				end
				SWITCHES:
				begin
					enable_LEDS 		= 1'b0;
					enable_SWITCHES 	= 1'b1;
					enable_MemWrite	= MemWrite;
					enable_SendTx		=	1'b0;
					reset_UART_READY	= 1'b0;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = HRDATA_IN_GPIO;
					HWDATA_OUT = 'h0;
				end
				INSTR_MEMORY:
				begin
					enable_LEDS 				= 1'b0;
					enable_SWITCHES 			= 1'b1;
					enable_MemWrite			= MemWrite;
					enable_SendTx				=	1'b0;
					reset_UART_READY			= 1'b0;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = 'h0;
					HWDATA_OUT = 'h0;
				end
				DATA_MEMORY:
				begin
					enable_LEDS 				= 1'b0;
					enable_SWITCHES 			= 1'b1;
					enable_MemWrite			= MemWrite;
					enable_SendTx				=	1'b0;
					reset_UART_READY			= 1'b0;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = HRDATA_IN_DATA_MEMORY;
					HWDATA_OUT = 'h0;
				end
				UART_TX:
				begin
					enable_LEDS 		= 1'b0;
					enable_SWITCHES 	= 1'b1;
					enable_MemWrite	= MemWrite;
					enable_SendTx		=	1'b1;
					reset_UART_READY	= 1'b0;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = 'h0;
					HWDATA_OUT = HWDATA_IN;
				end
				UART_RX:
				begin
					enable_LEDS 		= 1'b0;
					enable_SWITCHES 	= 1'b0;
					enable_MemWrite	= MemWrite;
					enable_SendTx		=	1'b0;
					reset_UART_READY	= 1'b1;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = {{24{1'b0}},HRDATA_IN_UART[7:0]};
					HWDATA_OUT = 'h0;
				end
				UART_BUSY:
				begin
					enable_LEDS 		= 1'b0;
					enable_SWITCHES 	= 1'b0;
					enable_MemWrite	= MemWrite;
					enable_SendTx		=	1'b0;
					reset_UART_READY	= 1'b0;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = {{31{1'b0}},HRDATA_IN_UART_BUSY};
					HWDATA_OUT = HWDATA_IN;
				end
				UART_READY:
				begin
					enable_LEDS 		= 1'b0;
					enable_SWITCHES 	= 1'b0;
					enable_MemWrite	= MemWrite;
					enable_SendTx		=	1'b0;
					reset_UART_READY	= 1'b0;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = {{31{1'b0}},HRDATA_IN_UART_READY};
					HWDATA_OUT = 'h0;
				end
				default:
				begin
					enable_LEDS 		= 1'b0;
					enable_SWITCHES 	= 1'b1;
					enable_MemWrite	= 1'b0;
					enable_SendTx		=	1'b0;
					reset_UART_READY	= 1'b1;
					HRDATA_OUT_Instr = HRDATA_IN_INSTR_MEMORY;
					HRDATA_OUT_Data = HRDATA_IN_DATA_MEMORY;
					HWDATA_OUT = 'h0;
				end
			endcase
    end

endmodule