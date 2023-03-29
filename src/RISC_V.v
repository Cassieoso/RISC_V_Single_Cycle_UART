module RISC_V #(parameter LENGTH = 32)(
    input clock,reset,
	 input [LENGTH-1:0] HRDATA,
	 output MemWrite,
//	 output [LENGTH-1:0] ALUResult_Reg_w,
	 output [LENGTH-1:0] RegisterFile_RD2_reg_w,
	 output [LENGTH-1:0] MUX1_Output_w
    );

	 
	 
    wire [LENGTH-1:0]programCounter_Output_w; 
//    wire [LENGTH-1:0]MUX1_Output_w;              //Mux to ProgramCounter and InstructionDataMemory
    wire [LENGTH-1:0]InstructionData_Memory_RD_w;
    wire [LENGTH-1:0]InstructionData_Memory_RD_Reg1_w;
    wire [LENGTH-1:0]InstructionData_Memory_RD_Reg2_w;
    wire [4:0] Mux_2in_1out_2_A3_w;
    wire [LENGTH-1:0] Mux_2in_1out_3_WD3_w;
    wire [LENGTH-1:0]RegisterFile_RD1_w;
    wire [LENGTH-1:0]RegisterFile_RD2_w;
    wire [LENGTH-1:0]RegisterFile_RD1_reg_w;
    //wire [LENGTH-1:0]RegisterFile_RD2_reg_w;
    wire [31:0] Mux_2in_1out_4_SrcA_w;
    wire [31:0] Mux_2in_1out_4_SrcB_w;
    wire [LENGTH-1:0] signExtend_w;
    //wire [LENGTH-1:0] branch_w;
    wire [LENGTH-1:0] ALUResult_Reg_w;
    wire [LENGTH-1:0] ALUResult_MUX_w;
	 wire [LENGTH-1:0] ALU_Result;
	 wire [LENGTH-1:0] immediate_w;
	 wire [2:0] immediateSel;
	 wire PCEn;
	 wire zero;
//	 wire [LENGTH-1:0] programCounter_decode_Output_w;
//	 wire [LENGTH-1:0] memoryAddress_decode_w;
//	 wire [LENGTH-1:0] Address_decode_w;
	 wire [LENGTH-1:0] Mux_2in_1out_3_WD_mux_w;
	 
//For controlUnit
    wire [1:0] MemtoReg;
    wire RegDst;
    wire IorD;
    wire PCSrc;
    wire [1:0] ALUSrcB;
    wire ALUSrcA;
    wire IRWrite;
//    wire MemWrite;
    wire PCWrite;
    wire RegWrite;
    wire [2:0]ALUControl;
	 wire BranchEQ;
	 wire BranchNE;


programCounter  #(.LENGTH(LENGTH)) programCounter_TOP(
    .clock(clock),
    .reset(reset),
    .enable(PCEn),                   //This enable has to come from FSM
    .D(ALUResult_MUX_w),
    .Q(programCounter_Output_w)     //It goes to PC Instr/Data Memory MUX
    );
	 
//programCounter_decode  #(.LENGTH(LENGTH)) programCounter_decode_TOP(
//    .clock(clock),
//    .reset(reset),
//    .enable(PCEn),                   //This enable has to come from FSM
//    .D(programCounter_Output_w),
//    .Q(programCounter_decode_Output_w)     //It goes to PC Instr/Data Memory MUX
//    );
//	 
//memoryAddress_decode  #(.LENGTH(LENGTH)) memoryAddress_decode_TOP(
//    .clock(clock),
//    .reset(reset),
//    .enable(1'b1),                   //This enable has to come from FSM
//    .D(ALUResult_Reg_w),
//    .Q(memoryAddress_decode_w)     //It goes to PC Instr/Data Memory MUX
//    );
	 
//Address_decode  #(.LENGTH(LENGTH)) Address_decode_TOP(
//    .clock(clock),
//    .reset(reset),
//    .enable(1'b1),                   //This enable has to come from FSM
//    .D(MUX1_Output_w),
//    .Q(Address_decode_w)     //It goes to PC Instr/Data Memory MUX
//    );

Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_1(       //Mux to ProgramCounter and InstructionDataMemory
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                   //Does it have to be always enabled?
    .A(programCounter_Output_w),
    .B(ALUResult_Reg_w),             //This B has to come from ALU RESULT //Antes tenia ALUResult_Reg_w
    .sel(IorD),                       //This sel has to come from FSM
    .Q(MUX1_Output_w)
    );

//InstructionData_Memory InstructionData_Memory_TOP (
//    .clk(clock),
//    .addr(MUX1_Output_w),
//    .data(RegisterFile_RD2_reg_w),                    //This data has to come from RD2 Register
//    .we(MemWrite),                       //This we has to come from FSM
//    .RD(InstructionData_Memory_RD_w)
//    );

register #(.LENGTH_v(LENGTH)) register_1(        //InstructionData_Memory RD
    .clock(clock),
    .reset(reset),
    .enable(IRWrite),                          //This enable has to come from FSM
    .D(HRDATA),
    .Q(InstructionData_Memory_RD_Reg1_w)    //It goes to RegisterFile
    );

register #(.LENGTH_v(LENGTH)) register_2(       //InstructionData_Memory RD
    .clock(clock),
    .reset(reset),
    .enable(1'b1),                          //Does it have to be always enabled?
    .D(HRDATA),
    .Q(InstructionData_Memory_RD_Reg2_w)    //It goes to MUX WD3
    );
	 
//Mux_2in_1out #(.LENGTH(32)) Mux_2in_1out_3(
//    .clk(clock),
//    .rst(reset),
//    .enable(1'b1),           
//    .A(InstructionData_Memory_RD_Reg2_w), 
//    .B(HRDATA),                      
//    .sel(enable_WRITE),                        
//    .Q(Mux_2in_1out_3_WD_mux_w)
//    );

Mux_2in_1out #(.LENGTH(5)) Mux_2in_1out_2(      //InstructionData_Memory RD to A3 RegisterFile
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                      //This enable has to come from FSM or Does it have to be always enabled?
    .A(InstructionData_Memory_RD_Reg1_w[19:15]), //Cambio para RISC-V
    .B(InstructionData_Memory_RD_Reg1_w[11:7]),    //Cambio para RISC-V                     
    .sel(RegDst),                         //This sel has to come from FSM    
    .Q(Mux_2in_1out_2_A3_w)
    );

//Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_3(    //InstructionData_Memory RD to WD3 RegisterFile
//    .clk(clock),
//    .rst(reset),
//    .enable(1'b1),                      //This enable has to come from FSM or Does it have to be always enabled?
//    .A(ALUResult_Reg_w),             //This B has to come from ALU Out //Antes tenia ALUResult_Reg_w
//    .B(InstructionData_Memory_RD_Reg2_w),
//    .sel(MemtoReg),                         //This sel has to come from FSM               
//    .Q(Mux_2in_1out_3_WD3_w)
//    );

Mux_3in_1out #(.LENGTH(LENGTH)) Mux_3in_1out_1(    //InstructionData_Memory RD to WD3 RegisterFile
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                      //This enable has to come from FSM or Does it have to be always enabled?
    .A(ALUResult_Reg_w),             //This B has to come from ALU Out //Antes tenia ALUResult_Reg_w
    .B(InstructionData_Memory_RD_Reg2_w),
	 .C(programCounter_Output_w),
    .sel(MemtoReg),                         //This sel has to come from FSM               
    .Q(Mux_2in_1out_3_WD3_w)
    );
	
RegisterFile #(.DATA_WIDTH(32), .ADDR_WIDTH(5))RegisterFile_TOP(
    .clk(clock),
    .reset(reset),
    .A1(InstructionData_Memory_RD_Reg1_w[19:15]),
    .A2(InstructionData_Memory_RD_Reg1_w[24:20]),
    .A3(Mux_2in_1out_2_A3_w),
    .WD3(Mux_2in_1out_3_WD3_w),
    .WE3(RegWrite),                     //This WE3 has to come from FSM  
    .RD1(RegisterFile_RD1_w),                     
    .RD2(RegisterFile_RD2_w)
    );

register #(.LENGTH_v(LENGTH)) register_3(       //RegisterFile RD1
    .clock(clock),
    .reset(reset),
    .enable(1'b1),                      //Does it have to be always enabled?
    .D(RegisterFile_RD1_w),
    .Q(RegisterFile_RD1_reg_w)
    );

register #(.LENGTH_v(LENGTH)) register_4(       //RegisterFile RD2
    .clock(clock),
    .reset(reset),
    .enable(1'b1),                      //Does it have to be always enabled?
    .D(RegisterFile_RD2_w),
    .Q(RegisterFile_RD2_reg_w)
    );

signExtend signExtend_TOP(
    .clock(clock),
    .reset(reset),
    .enable(1'b1),                      //Does it have to be always enabled?
    .extend(InstructionData_Memory_RD_Reg1_w[15:0]),
    .extended(signExtend_w)
    );
	 
//zeroExtend zeroExtend_TOP(
//    .clock(clock),
//    .reset(reset),
//    .enable(1'b1),                      //Does it have to be always enabled?
//    .extend(InstructionData_Memory_RD_Reg1_w[15:0]),
//    .extended(zeroExtend_w)
//    );

//BranchAddress BranchAddress_TOP( //Para obtener la direccion a la que se brincara
//    .clock(clock),
//    .reset(reset),
//    .enable(1'b1),
//    .immediate1107(InstructionData_Memory_RD_Reg1_w[11:7]),
//	 .immediate3125(InstructionData_Memory_RD_Reg1_w[31:25]),
//    .branch(branch_w)
//    );

ImmediateDecode ImmediateDecode_TOP(
    .sel(immediateSel),
    .instruction(InstructionData_Memory_RD_Reg1_w[31:0]),
    .immediate(immediate_w)
    );
	 

Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_4(       //RegisterFile to ALU
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                    
    .A(programCounter_Output_w),
    .B(RegisterFile_RD1_reg_w),                         
    .sel(ALUSrcA),                       //This sel has to come from FSM 
    .Q(Mux_2in_1out_4_SrcA_w)
    );

Mux_4in_1out #(.LENGTH(LENGTH)) Mux_4in_1out(       
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                   
    .A(RegisterFile_RD2_reg_w),
    .B(32'h00000004),
    .C(signExtend_w),                       //Sign Extender
    .D(immediate_w),                       //??
    .sel(ALUSrcB),                     //This sel has to come from FSM 
    .Q(Mux_2in_1out_4_SrcB_w)
    );

register #(.LENGTH_v(LENGTH)) register_5(
    .clock(clock),
    .reset(reset),
    .enable(1'b1),
    .D(ALU_Result),                   //This D has to come from ALU
    .Q(ALUResult_Reg_w)
    );

Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_5(       
    .clk(clock),
    .rst(reset),
    .enable(1'b1),               //??
    .A(ALU_Result),                   //This A has to come from ALU
    .B(ALUResult_Reg_w),                         
    .sel(PCSrc),                 //This sel has to come from FSM 
    .Q(ALUResult_MUX_w)
    );
	 
ALU #(.LENGTH(LENGTH)) ALU_TOP(       
    .clk(clock),
    .ALU_Sel(ALUControl),               //??
    .A(Mux_2in_1out_4_SrcA_w),                   //This A has to come from ALU
    .B(Mux_2in_1out_4_SrcB_w),                         
    .shamt(InstructionData_Memory_RD_Reg1_w[10:6]),                 //This sel has to come from FSM 
    .ALU_Out(ALU_Result),
	 .zero(zero)
    );

controlUnit controlUnit_TOP(
    .clk(clock),
    .rst(reset),
	 .opCode(InstructionData_Memory_RD_Reg1_w[6:0]), //Actualizado para RISC V
    //Multiplexer Selects
    .MemtoReg(MemtoReg),
    .RegDst(RegDst),
    .IorD(IorD),
    .PCSrc(PCSrc),
    .ALUSrcB(ALUSrcB),
    .ALUSrcA(ALUSrcA),
    //Register Enables
    .IRWrite(IRWrite),
    .MemWrite(MemWrite),
    .PCWrite(PCWrite),
    .RegWrite(RegWrite),
	 .BranchEQ(BranchEQ),
	 .BranchNE(BranchNE),
	 .immediateSel(immediateSel),
    //To ALU Decoder
    .funct(InstructionData_Memory_RD_Reg1_w[14:12]), //Actualizado para RISC V
	 .funct7(InstructionData_Memory_RD_Reg1_w[31:25]), //Actualizado para RISC V
    .ALUControl(ALUControl)
    );
	 
	 
assign PCEn = ((zero & BranchEQ) | (~zero & BranchNE)) | PCWrite;

endmodule




// register #(.LENGTH_v(LENGTH)) register_1(
//     .clock(clock),
//     .reset(reset),
//     .enable(),
//     .D(),
//     .Q()
//     );


// Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_1(       
//     .clk(clock),
//     .rst(reset),
//     .enable(),                   
//     .A(),
//     .B(),                         
//     .sel(),                       
//     .Q()
//     );