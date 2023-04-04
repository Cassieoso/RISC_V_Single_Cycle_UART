module RISC_V_Single_Cycle
(
	//Inputs
	input clk,
	input reset,
	//Output
	output clk_out,
	//GPIO
	output [7:0] gpio_port_out,
	input [7:0] gpio_port_in,
	//UART
	input rx,
	output parity,
//	output [8:0]Rx_SR,
	output heard_bit_out,
	output [6:0] HEX0,
	output [6:0] HEX2,
	output [6:0] HEX3,
//	input sendTx,
//	input sw00,sw01,sw02,sw03,sw04,sw05,sw06,sw07,
	output tx
);

wire enable_WRITE;
wire [31:0] HWDATA;
wire [31:0] HADDR;
wire [31:0] HADDR_Instr;
//wire [31:0] HADDR_Data;
wire [31:0] HADDR_Instr_decoded;
//wire [31:0] HADDR_Data_decoded;
wire [31:0] HADDR_decoded;
wire enable_LEDS;
wire enable_SWITCHES;
wire enable_MemWrite;
wire enable_SendTx;
wire reset_UART_READY;
wire [31:0] HRDATA_OUT_Data;
wire [31:0] HRDATA_OUT_Instr;
wire [31:0] HWDATA_OUT;
wire [31:0] HRDATA_IN_GPIO;
wire [31:0] HRDATA_IN_INSTR_MEMORY;
wire [31:0] HRDATA_IN_DATA_MEMORY;
wire [7:0] HRDATA_IN_UART;
wire HRDATA_IN_UART_BUSY;
wire HRDATA_IN_UART_READY;


RISC_V #(.LENGTH(32)) RISC_V_TOP(
    .clock(clk),
	 .reset(reset),
//	 .enable_WRITE(enable_WRITE),
	 .HRDATA_Instr(HRDATA_OUT_Instr),
	 .HRDATA_Data(HRDATA_OUT_Data),
//	 .ALUResult_Reg_w(HADDR),
	 .RegisterFile_RD2_w(HWDATA),
	 .MemWrite(MemWrite),
	 .HADDR(HADDR),
	 .programCounter_Output(HADDR_Instr)
//	 .ALU_Result(HADDR_Data)
//	 .memoryAddress_decode_w(HADDR)
    );

	 
//Modulo X
PCH PCH_TOP(
    .clk(clk),
	 .reset(reset),
//	 .HADDR_Instr(HADDR_Instr),
//	 .HADDR_Data(HADDR_Data),
	 .HADDR(HADDR),
	 .MemWrite(MemWrite),
	 .HRDATA_IN_GPIO(HRDATA_IN_GPIO),
	 .HRDATA_IN_INSTR_MEMORY(HRDATA_IN_INSTR_MEMORY),
	 .HRDATA_IN_DATA_MEMORY(HRDATA_IN_DATA_MEMORY),
	 .HRDATA_IN_UART(HRDATA_IN_UART),
	 .HRDATA_IN_UART_BUSY(HRDATA_IN_UART_BUSY),
	 .HRDATA_IN_UART_READY(HRDATA_IN_UART_READY),
	 .HWDATA_IN(HWDATA),
	 .HWDATA_OUT(HWDATA_OUT),
	 .enable_LEDS(enable_LEDS),
	 .enable_SWITCHES(enable_SWITCHES),
	 .enable_MemWrite(enable_MemWrite),
	 .enable_SendTx(enable_SendTx),
	 .reset_UART_READY(reset_UART_READY),
//	 .enable_WRITE(enable_WRITE),
	 .HRDATA_OUT_Instr(HRDATA_OUT_Instr),
    .HRDATA_OUT_Data(HRDATA_OUT_Data)
    );
	

Address_decode  #(.LENGTH(32)) Address_decode_TOP(
    .clock(clk),
    .reset(reset),
    .enable(1'b1),                   //This enable has to come from FSM
    .D(HADDR),
    .Q(HADDR_decoded)     //It goes to PC Instr/Data Memory MUX
    );
	 	
Address_decode  #(.LENGTH(32)) Instr_Address_decode_TOP(
    .clock(clk),
    .reset(reset),
    .enable(1'b1),                   //This enable has to come from FSM
    .D(HADDR_Instr),
    .Q(HADDR_Instr_decoded)     //It goes to PC Instr/Data Memory MUX
    );
	 
//Address_decode  #(.LENGTH(32)) Data_Address_decode_TOP(
//    .clock(clk),
//    .reset(reset),
//    .enable(1'b1),                   //This enable has to come from FSM
//    .D(HADDR_Data),
//    .Q(HADDR_Data_decoded)     //It goes to PC Instr/Data Memory MUX
//    );
//	 
Instruction_Memory Instruction_Memory_TOP (
    .clk(clk),
    .addr(HADDR_Instr_decoded),
    .data(HWDATA),
    .we(1'b0),
	 .RD(HRDATA_IN_INSTR_MEMORY)
    );
	 
Data_Memory Data_Memory_TOP (	//En la presentacion aparece un MemRead pero menciona que es lectura asincrona
    .clk(clk),
    .addr(HADDR_decoded),
    .data(HWDATA),
    .we(enable_MemWrite),
    .RD(HRDATA_IN_DATA_MEMORY)
    );
	  
GPIO GPIO_TOP(
    .clk(clk),
	 .reset(reset),
	 .enable_LEDS(enable_LEDS),
	 .enable_SWITCHES(enable_SWITCHES),
    .gpio_port_in(gpio_port_in),
	 .HWDATA(HWDATA_OUT),
	 .gpio_port_out(gpio_port_out),
	 .HRDATA(HRDATA_IN_GPIO)
    );


UART_TxRx UART_TOP(
	.clock(clk),
	.reset(~reset),
	//UART_Rx
	.rx(rx),
	.parity(parity),
	.Rx_SR(HRDATA_IN_UART),
	.heard_bit_out(heard_bit_out),
	.HEX0(HEX0),
	.HEX2(HEX2),
	.HEX3(HEX3),
	//UART_Tx
	.sendTx(enable_SendTx),					//Apretar para enviar, tendra que ser enviado por el PCH
	.sw00(HWDATA_OUT[24]),		//Todos estos deben de venir del PCH, que es el modulo X, falta la logica
	.sw01(HWDATA_OUT[25]),
	.sw02(HWDATA_OUT[26]),
	.sw03(HWDATA_OUT[27]),
	.sw04(HWDATA_OUT[28]),
	.sw05(HWDATA_OUT[29]),
	.sw06(HWDATA_OUT[30]),
	.sw07(HWDATA_OUT[31]),
	.tx(tx),								//Salida hacia el serial
	.UART_BUSY(HRDATA_IN_UART_BUSY),			//Avisa si ya termino de enviar, deberia enviarse de vuelta al PCH para enviar los siguientes 8 bits
	.enable_out_rx(HRDATA_IN_UART_READY),
	.reset_UART_READY(reset_UART_READY)
);
	 
endmodule