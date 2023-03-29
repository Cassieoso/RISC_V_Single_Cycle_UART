module MIPS #(parameter LENGTH = 32)(
    input clock,reset
    );

    wire [LENGTH-1:0]programCounter_Output_w; 
    wire [LENGTH-1:0]MUX1_Output_w;              //Mux to ProgramCounter and InstructionDataMemory
    wire [LENGTH-1:0]InstructionData_Memory_RD_w;
    wire [LENGTH-1:0]InstructionData_Memory_RD_Reg1_w;
    wire [LENGTH-1:0]InstructionData_Memory_RD_Reg2_w;
    wire [4:0] Mux_2in_1out_2_A3_w;
    wire [LENGTH-1:0] Mux_2in_1out_3_WD3_w;
    wire [LENGTH-1:0]RegisterFile_RD1_w;
    wire [LENGTH-1:0]RegisterFile_RD2_w;
    wire [LENGTH-1:0]RegisterFile_RD1_reg_w;
    wire [LENGTH-1:0]RegisterFile_RD2_reg_w;
    wire [31:0] Mux_2in_1out_4_SrcA_w;
    wire [31:0] Mux_2in_1out_4_SrcB_w;
    wire [LENGTH-1:0] signExtend_w;
    wire [LENGTH-1:0] zeroExtend_w;
    wire [LENGTH-1:0] ALUResult_Reg_w;
    wire [LENGTH-1:0] ALUResult_MUX_w;
	 wire [LENGTH-1:0] ALU_Result;
	 
//For controlUnit
    wire MemtoReg;
    wire RegDst;
    wire IorD;
    wire PCSrc;
    wire [1:0] ALUSrcB;
    wire ALUSrcA;
    wire IRWrite;
    wire MemWrite;
    wire PCWrite;
    wire RegWrite;
    wire [2:0]ALUControl;


programCounter  #(.LENGTH(LENGTH)) programCounter_TOP(
    .clock(clock),
    .reset(reset),
    .enable(PCWrite),                   //This enable has to come from FSM
    .D(ALUResult_MUX_w),
    .Q(programCounter_Output_w)     //It goes to PC Instr/Data Memory MUX
    );

Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_1(       //Mux to ProgramCounter and InstructionDataMemory
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                   //Does it have to be always enabled?
    .A(programCounter_Output_w),
    .B(ALU_Result),             //This B has to come from ALU RESULT //Antes tenia ALUResult_Reg_w
    .sel(IorD),                       //This sel has to come from FSM
    .Q(MUX1_Output_w)
    );

InstructionData_Memory InstructionData_Memory_TOP (
    .clk(clock),
    .addr(MUX1_Output_w),
    .data(RegisterFile_RD2_reg_w),                    //This data has to come from RD2 Register
    .we(MemWrite),                       //This we has to come from FSM
    .RD(InstructionData_Memory_RD_w)
    );

register #(.LENGTH_v(LENGTH)) register_1(        //InstructionData_Memory RD
    .clock(clock),
    .reset(reset),
    .enable(IRWrite),                          //This enable has to come from FSM
    .D(InstructionData_Memory_RD_w),
    .Q(InstructionData_Memory_RD_Reg1_w)    //It goes to RegisterFile
    );

register #(.LENGTH_v(LENGTH)) register_2(       //InstructionData_Memory RD
    .clock(clock),
    .reset(reset),
    .enable(1'b1),                          //Does it have to be always enabled?
    .D(InstructionData_Memory_RD_w),
    .Q(InstructionData_Memory_RD_Reg2_w)    //It goes to MUX WD3
    );

Mux_2in_1out #(.LENGTH(5)) Mux_2in_1out_2(      //InstructionData_Memory RD to A3 RegisterFile
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                      //This enable has to come from FSM or Does it have to be always enabled?
    .A(InstructionData_Memory_RD_Reg1_w[20:16]),
    .B(InstructionData_Memory_RD_Reg1_w[15:11]),                         
    .sel(RegDst),                         //This sel has to come from FSM    
    .Q(Mux_2in_1out_2_A3_w)
    );

Mux_2in_1out #(.LENGTH(LENGTH)) Mux_2in_1out_3(    //InstructionData_Memory RD to WD3 RegisterFile
    .clk(clock),
    .rst(reset),
    .enable(1'b1),                      //This enable has to come from FSM or Does it have to be always enabled?
    .A(ALU_Result),             //This B has to come from ALU Out //Antes tenia ALUResult_Reg_w
    .B(InstructionData_Memory_RD_Reg2_w),
    .sel(MemtoReg),                         //This sel has to come from FSM               
    .Q(Mux_2in_1out_3_WD3_w)
    );

RegisterFile #(.DATA_WIDTH(32), .ADDR_WIDTH(5))RegisterFile_TOP(
    .clk(clock),
    .reset(reset),
    .A1(InstructionData_Memory_RD_Reg1_w[25:21]),
    .A2(InstructionData_Memory_RD_Reg1_w[20:16]),
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
	 
zeroExtend zeroExtend_TOP(
    .clock(clock),
    .reset(reset),
    .enable(1'b1),                      //Does it have to be always enabled?
    .extend(InstructionData_Memory_RD_Reg1_w[15:0]),
    .extended(zeroExtend_w)
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
    .B(32'h00000001),
    .C(signExtend_w),                       //Sign Extender
    .D(zeroExtend_w),                       //??
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
    .ALU_Out(ALU_Result)
    );

controlUnit controlUnit_TOP(
    .clk(clock),
    .rst(reset),
	 .opCode(InstructionData_Memory_RD_Reg1_w[31:26]),
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
    //To ALU Decoder
    .funct(InstructionData_Memory_RD_Reg1_w[5:0]),
    .ALUControl(ALUControl)
    );
	 

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