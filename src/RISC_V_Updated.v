module RISC_V_Updated #(parameter LENGTH = 32)(
    input clock,reset,
	 input [LENGTH-1:0] HRDATA,
	 output MemWrite,
	 output [LENGTH-1:0] RegisterFile_RD2_w,
	 output [LENGTH-1:0] HADDR
    );
	 
wire [LENGTH-1:0] programCounter_Output;
wire [LENGTH-1:0] programCounter_Output_mux;
wire [LENGTH-1:0] programCounter_Output_normal;
wire [LENGTH-1:0] programCounter_Output_branch;
wire [LENGTH-1:0] immediate_w;
wire [LENGTH-1:0] ALU_Out;
wire [LENGTH-1:0] RegisterFile_RD1_w;
//wire [LENGTH-1:0] RegisterFile_RD2_w;
wire [LENGTH-1:0] RD2_Imm_mux_w;
wire [LENGTH-1:0] ALU_Result;
wire [LENGTH-1:0] ALU_DataMem_mux;
wire [2:0] immediateSel;
wire PCSrc;
wire HADDR_Sel;
wire ALUSrc;
wire [2:0] ALUOp;
wire [2:0] ALUControl;
wire zero;
wire MemtoReg;
wire RegDst;
wire [4:0] RegisterFile_A3_w;
wire Branch;
wire MemRead;
wire RegWrite;


programCounter  #(.LENGTH(LENGTH)) programCounter_TOP( //PC
    .clock(clock),
    .reset(reset),
    .enable(1'b1),
    .D(programCounter_Output_mux),
    .Q(programCounter_Output)
    );
	 
ImmediateDecode ImmediateDecode_TOP( //Imm gen
    .sel(immediateSel),
    .instruction(HRDATA),
    .immediate(immediate_w)
    );
	 
Adder_param #(.LENGTH(LENGTH)) Adder_param_PC( //Adder when there is no branches
	.A(programCounter_Output),
	.B('h4),
	.Q(programCounter_Output_normal)
);

Adder_param #(.LENGTH(LENGTH)) Adder_param_Branch( //Adder for branches
	.A(programCounter_Output),
	.B(immediate_w),
	.Q(programCounter_Output_branch)
);

Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_1(       //Mux to ProgramCounter
    .clk(clock),
    .rst(reset),
    .enable(1'b1),
    .A(programCounter_Output_normal),
    .B(programCounter_Output_branch),
    .sel(PCSrc),
    .Q(programCounter_Output_mux)
    );
	 
Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_2(       //Mux for HADDR
    .clk(clock),
    .rst(reset),
    .enable(1'b1),
    .A(programCounter_Output),
    .B(ALU_Result),
    .sel(HADDR_Sel),	//Y este selector debe venir de la control unit
    .Q(HADDR)
    );
	 
Mux_2in_1out #(.LENGTH(5)) Mux_2in_1out_5(       //Mux after data memory (final mux)
    .clk(clock),
    .rst(reset),
    .enable(1'b1),
    .A(HRDATA[19:15]),
    .B(HRDATA[11:7]),		//Todavia falta la ALU
    .sel(RegDst),	//Y este selector debe venir de la control unit
    .Q(RegisterFile_A3_w)
    );
	 

RegisterFile #(.DATA_WIDTH(LENGTH), .ADDR_WIDTH(5)) RegisterFile_TOP(
    .clk(clock),
    .reset(reset),
    .A1(HRDATA[19:15]),
    .A2(HRDATA[24:20]),
    .A3(RegisterFile_A3_w),
    .WD3(ALU_DataMem_mux),				//Debe venir del ultimo mux, aun no agregado
    .WE3(RegWrite),	//Debe venir de la control unit
    .RD1(RegisterFile_RD1_w),                     
    .RD2(RegisterFile_RD2_w)
    );
	 
Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_3(       //Mux for HADDR
    .clk(clock),
    .rst(reset),
    .enable(1'b1),
    .A(RegisterFile_RD2_w),
    .B(immediate_w),		//Todavia falta la ALU
    .sel(ALUSrc),	//Y este selector debe venir de la control unit
    .Q(RD2_Imm_mux_w)
    );
	 
ALU_Control ALU_Control_TOP(
	.rst(reset),
	.ALUOp(ALUOp),		//Debe venir de la control unit
	.funct(HRDATA[14:12]),
	.funct7(HRDATA[14:12]),
	.opCode(HRDATA[6:0]),
	.ALUControl(ALUControl)
    );
	 
ALU #(.LENGTH(LENGTH)) ALU_TOP(       
    .clk(clock),
    .ALU_Sel(ALUControl),
    .A(RegisterFile_RD1_w),
    .B(RD2_Imm_mux_w),                         
    .shamt(HRDATA[10:6]),
    .ALU_Out(ALU_Result),
	 .zero(zero)
    );
	 
Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_4(       //Mux after data memory (final mux)
    .clk(clock),
    .rst(reset),
    .enable(1'b1),
    .A(ALU_Result),
    .B(HRDATA),		//Todavia falta la ALU
    .sel(MemtoReg),	//Y este selector debe venir de la control unit
    .Q(ALU_DataMem_mux)
    );
	 
ControlUnit_SC ControlUnit(
    .clk(clock),
	 .rst(reset),
    .opCode(HRDATA[6:0]),
	 .Branch(Branch),
	 .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
	 .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
	 .HADDR_Sel(HADDR_Sel),
	 .RegDst(RegDst),
	 .immediateSel(immediateSel),
    .ALUOp(ALUOp)
);

assign PCSrc = zero & Branch;

endmodule
