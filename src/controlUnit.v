module controlUnit (
    input clk, rst,
    input [6:0]opCode,
    //Multiplexer Selects
    output reg [1:0] MemtoReg,
    output reg RegDst,
    output reg IorD,
    output reg PCSrc,
    output reg [1:0] ALUSrcB,
    output reg ALUSrcA,
    //Register Enables
    output reg IRWrite,
    output reg MemWrite,
    output reg PCWrite,
    output reg RegWrite,
	 output reg BranchEQ,
	 output reg BranchNE,
	 output reg [2:0] immediateSel,
    //To ALU Decoder
    input [2:0] funct,
	 input [6:0] funct7,
    // input [1:0]ALUOp,               //??
    output reg [2:0]ALUControl
    //output reg [1:0] ALUOp          //??
    );

reg [2:0]ALUOp; //Cambiado 27/02

reg [4:0] state;

localparam S0_FETCH	 				 = 5'b00000;
localparam S1_DECODE  				 = 5'b00001;
localparam S2_BEQ						= 5'b00010;
localparam S3_BNE						= 5'b00011;
localparam S4_JAL_WRITEREG			= 5'b00100;
localparam S5_JAL_JALR_ADDPC		= 5'b00101;
localparam S6_JALR_WRITEREG		= 5'b00110;
localparam S7_AUIPC_EXECUTE		= 5'b00111;
localparam S8_ALUWRITEBACK			= 5'b01000;
localparam S9_I_EXECUTE				= 5'b01001;
localparam S10_ALUWRITEBACK		= 5'b01010;
localparam S11_MEMADR				= 5'b01011;
localparam S12_MEMREAD				= 5'b01100;
localparam S13_MEMWRITEBACK		= 5'b01101;
localparam S14_MEMADR_SW			= 5'b01110;
localparam S15_MEMWRITE				= 5'b01111;
//localparam S16_I_EXECUTE_I			= 5'b10000;
localparam S16_R_EXECUTE			= 5'b10000;
//localparam S2_MEM_ADDR = 4'b0010;
//localparam S3_MEM_READ = 4'b0011;
//localparam S4_MEM_WRITE_BACK = 4'b0100;
//localparam S5_MEM_WRITE      = 4'b0101;
//localparam S6_EXECUTE        = 4'b0110;
//localparam S7_ALU_WRITE_BACK = 4'b0111;
//// S8_BRANCH???
//localparam S9_ADDI_EXECUTE     = 4'b1001;
//localparam S10_ADDI_WRITE_BACK = 4'b1010;
//localparam S11_ANDI_EXECUTE	 = 4'b1011;
//localparam S12_ANDI_WRITE_BACK = 4'b1100;

//ALU Decoder
localparam ADD_FN	= 3'b000;
localparam SUB_FN	= 3'b100;
localparam AND_FN	= 3'b111;
localparam OR_FN	= 3'b110;
localparam SLL_FN	= 3'b001;
localparam SRL_FN	= 3'b101;
localparam SLT_FN	= 3'b010;
localparam SLTU_FN = 3'b011;
reg [2:0] ALUFunctions_o;

//localparam LW = 6'h23;
//localparam SW = 6'h2b;
//localparam R_Type = 6'h00;
localparam B_Type = 7'b1100011;
localparam J_Type = 7'b1101111;
localparam I_Type = 7'b0010011;
localparam S_Type = 7'b0100011;
localparam R_Type = 7'b0110011;
localparam BEQ = 3'b000;
localparam BNE = 3'b001;
localparam JALR = 7'b1100111;
localparam AUIPC = 7'b0010111;
localparam LW	= 7'b0000011;
localparam SW	=	3'b010;
//localparam ADDI_INS = 6'h08;
//localparam ANDI_INS = 6'h0C;

always @(posedge rst, posedge clk)
	begin
		if (rst) 
			state <= S0_FETCH;
		else 
		case (state)
            S0_FETCH:
                state <= S1_DECODE;
            S1_DECODE:
                if(opCode == B_Type)					 //Si la instruccion es BEQ
						if(funct == BEQ)
							state <= S2_BEQ;
						else if(funct == BNE)
							state <= S3_BNE;
						else
							state <=S0_FETCH;
					else if(opCode == J_Type)
						state <= S4_JAL_WRITEREG;
					else if(opCode == JALR)
						state <= S6_JALR_WRITEREG;
					else if(opCode == AUIPC)
						state <= S7_AUIPC_EXECUTE;
					else if(opCode == I_Type)
						state <= S9_I_EXECUTE;
					else if(opCode == LW)
						state <= S11_MEMADR;
					else if(opCode == S_Type)
						state <= S14_MEMADR_SW;
					else if(opCode == R_Type)
						state <= S16_R_EXECUTE;
					else
						  state <= S1_DECODE;
				S2_BEQ:
						state <= S0_FETCH;
				S3_BNE:
						state <= S0_FETCH;
				S4_JAL_WRITEREG:
						state <= S5_JAL_JALR_ADDPC;
				S5_JAL_JALR_ADDPC:
						state <= S0_FETCH;
				S6_JALR_WRITEREG:
						state <= S5_JAL_JALR_ADDPC;
				S7_AUIPC_EXECUTE:
						state <= S8_ALUWRITEBACK;
				S8_ALUWRITEBACK:
						state <= S0_FETCH;
				S9_I_EXECUTE:
						state <= S10_ALUWRITEBACK;
				S10_ALUWRITEBACK:
						state <= S0_FETCH;
				S11_MEMADR:
						state <= S12_MEMREAD;
				S12_MEMREAD:
						state <= S13_MEMWRITEBACK;
				S13_MEMWRITEBACK:
						state <= S0_FETCH;
				S14_MEMADR_SW:
						state <= S15_MEMWRITE;
				S15_MEMWRITE:
						state <= S0_FETCH;
				S16_R_EXECUTE:
						state <= S10_ALUWRITEBACK;
//				S17_R_ALUWRITEBACK:
//						state <= S0_FETCH;
//            S2_MEM_ADDR:
//                if(opCode == LW)            //Pseudocode 
//                    state <= S3_MEM_READ;
//                else
//                    if(opCode == SW)        //Pseudocode 
//                        state <= S5_MEM_WRITE;
//            S3_MEM_READ:
//                state <= S4_MEM_WRITE_BACK;
//            S4_MEM_WRITE_BACK:
//                state <= S0_FETCH;
//            S5_MEM_WRITE:
//                state <= S0_FETCH;
//            S6_EXECUTE:
//                state <= S7_ALU_WRITE_BACK;
//            S7_ALU_WRITE_BACK:
//                state <= S0_FETCH;
//            S9_ADDI_EXECUTE:
//                state <= S10_ADDI_WRITE_BACK;
//            S10_ADDI_WRITE_BACK:
//                state <= S0_FETCH;
//            S11_ANDI_EXECUTE:
//                state <= S12_ANDI_WRITE_BACK;
//            S12_ANDI_WRITE_BACK:
//                state <= S0_FETCH;
            default:
                state <= S0_FETCH;
		endcase
	end

always @(state)
	begin
        case(state)
				S0_FETCH: 	
					begin
                        //Multiplexer Selects
                        MemtoReg    = 2'b00;     //Appear as X
                        RegDst      = 1'b0;     //Appear as X
                        IorD        = 1'b0;     //change 0
                        PCSrc       = 1'b0;     //change 0
                        ALUSrcB     = 2'b01;    //change 01
                        ALUSrcA     = 1'b0;     //change 0
                        //Register Enables
                        IRWrite     = 1'b1;     //change 1
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b1;     //change 1
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;    //change 00
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000;
                    end
                S1_DECODE:          //this State change btw documents VERIFY IT
                    begin
                        //Multiplexer Selects
                        MemtoReg    = 2'b00;     //Appear as X
                        RegDst      = 1'b0;     //Appear as X
                        IorD        = 1'b0;     //change 0
                        PCSrc       = 1'b0;     //change 0
                        ALUSrcB     = 2'b11;    //change 11
                        ALUSrcA     = 1'b0;     //change 0
                        //Register Enables
                        IRWrite     = 1'b0;     //change 1
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;     //change 1
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;    //change 00
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b010;
                    end
					S2_BEQ:
							begin
                        MemtoReg    = 2'b00;     //Appear as X
                        RegDst      = 1'b0;     //Appear as X
                        IorD        = 1'b0;     //change 0
                        PCSrc       = 1'b1;     //change 0
                        ALUSrcB     = 2'b00;    //change 11
                        ALUSrcA     = 1'b1;     //change 0
                        //Register Enables
                        IRWrite     = 1'b0;     //change 1
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;     //change 1
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b001;    //change 00
								BranchEQ		= 1'b1;
								BranchNE		= 1'b0;
								immediateSel = 3'b010; //Para seleccionar B_TYPE
							end
					S3_BNE:
							begin
                        MemtoReg    = 2'b00;     //Appear as X
                        RegDst      = 1'b0;     //Appear as X
                        IorD        = 1'b0;     //change 0
                        PCSrc       = 1'b1;     //change 0
                        ALUSrcB     = 2'b00;    //change 11
                        ALUSrcA     = 1'b1;     //change 0
                        //Register Enables
                        IRWrite     = 1'b0;     //change 1
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;     //change 1
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b001;    //change 00
								BranchEQ		= 1'b0;
								BranchNE		= 1'b1;
								immediateSel = 3'b010; //Para seleccionar B_TYPE
							end
					S4_JAL_WRITEREG: //Hace la suma de PC + immediate y ademas guarda Rd = PC + 4 en el register file
							begin
                        MemtoReg    = 2'b10;     //Para que elija el PC
                        RegDst      = 1'b1;     //Guarda en la direccion de Rd
                        IorD        = 1'b0;     //change 0
                        PCSrc       = 1'b0;     //
                        ALUSrcB     = 2'b11;    //Selecciona el immediate
                        ALUSrcA     = 1'b0;     //Y el PC para hacer la suma
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b1;
                        //To ALU Decoder
                        ALUOp       = 3'b000;
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b100; //Para seleccionar J_TYPE
							end
					S5_JAL_JALR_ADDPC: //Manda al PC la nueva linea a la que se hizo jump
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b0;
                        PCSrc       = 1'b1;
                        ALUSrcB     = 2'b01;
                        ALUSrcA     = 1'b0;     //PC
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b1;     //Para mandar al PC el numero de instruccion al que brinco
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b100; //Para seleccionar J_TYPE
							end
					S6_JALR_WRITEREG:  //Hace la suma de rs1 + immediate y ademas guarda Rd = PC + 4 en el register file
							begin
                        MemtoReg    = 2'b10;     //Para que elija el PC
                        RegDst      = 1'b1;     //Guarda en la direccion de Rd
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;    //Selecciona el immediate
                        ALUSrcA     = 1'b1;     //Y el rs1 para hacer la suma
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b1;		//Habilita que se pueda escribir en el register file
                        //To ALU Decoder
                        ALUOp       = 3'b000;		//Va a sumar
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000; //Para seleccionar I_TYPE
							end
					S7_AUIPC_EXECUTE:  //Hace la suma de PC + immediate << 12
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;    //Selecciona el immediate
                        ALUSrcA     = 1'b0;		//Selecciona el PC
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;		//Va a sumar
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b101; //Para seleccionar U_TYPE
							end
					S8_ALUWRITEBACK:  //Manda el resultado de la ALU al registerfile
							begin
                        MemtoReg    = 2'b00;		//Guarda lo que hay en el PC
                        RegDst      = 1'b1;     //En la direccion de Rd
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b00;
                        ALUSrcA     = 1'b1;
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b1;		//Habilita que se pueda escribir en el register file
                        //To ALU Decoder
                        ALUOp       = 3'b000;
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b101; //Para seleccionar U_TYPE
							end
					S9_I_EXECUTE:  //Realiza la operacion destinada dependiendo del funct
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;		//Selecciona el immediate
                        ALUSrcA     = 1'b1;		//Y lo que hay en RS1
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b010;	//Para que haga la operacion indicada por funct
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000; //Para seleccionar I_TYPE
							end
					S10_ALUWRITEBACK:  //Envia el resultado de la ALU al register file en la direccion Rd
							begin
                        MemtoReg    = 2'b00;		//Escribe lo que hay en el PC
                        RegDst      = 1'b1;     //En la direccion de Rd
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;
                        ALUSrcA     = 1'b1;
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b1;		//Habilita que se pueda escribir en el register file
                        //To ALU Decoder
                        ALUOp       = 3'b010;
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000; //Para seleccionar I_TYPE
							end
					S11_MEMADR:  //Hace la suma del rs1 y el immediate
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;	//Selecciona el immediate
                        ALUSrcA     = 1'b1;	//Y el rs1
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;	//Y los suma
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000; //Para seleccionar I_TYPE
							end
					S12_MEMREAD:  //Y ese resultado lo utiliza como direccion para acceder al instruction memory
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b1;	//El ALU Out entra al instruction memory para sacar la instruccion
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;
                        ALUSrcA     = 1'b1;
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000;
							end
					S13_MEMWRITEBACK:  //Y lo guarda en el register file
							begin
                        MemtoReg    = 2'b01;	//Lo que hay en ese espacio del instruction memory
                        RegDst      = 1'b1;	//Lo escribe en la direccion Rd del register file
                        IorD        = 1'b1;	//Habilita que se escriba la salida de la ALU a la memoria
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;
                        ALUSrcA     = 1'b1;
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b1;	//Habilita la escritura al register file
                        //To ALU Decoder
                        ALUOp       = 3'b000;
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000;
							end
					S14_MEMADR_SW:  //Hace la suma del rs1 y el immediate
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;	//Selecciona el immediate
                        ALUSrcA     = 1'b1;	//Y el rs1
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;	//Y los suma
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b001; //Para seleccionar S_TYPE
							end
					S15_MEMWRITE:  //Escribe en la memoria el valor de Rs2
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b1;	//Se toma como direccion la salida de ALU Out
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b11;
                        ALUSrcA     = 1'b1;
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b1;	//Habilita escribir en memoria
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b000;
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b001;
							end
					S16_R_EXECUTE:  //Realiza la operacion destinada dependiendo del funct
							begin
                        MemtoReg    = 2'b00;
                        RegDst      = 1'b0;
                        IorD        = 1'b0;
                        PCSrc       = 1'b0;
                        ALUSrcB     = 2'b00;		//Selecciona lo que hay en RS2
                        ALUSrcA     = 1'b1;		//Y lo que hay en RS1
                        //Register Enables
                        IRWrite     = 1'b0;
                        MemWrite    = 1'b0;
                        PCWrite     = 1'b0;
                        RegWrite    = 1'b0;
                        //To ALU Decoder
                        ALUOp       = 3'b010;	//Para que haga la operacion indicada por funct
								BranchEQ		= 1'b0;
								BranchNE		= 1'b0;
								immediateSel = 3'b000; //R Type no tiene immediate
							end
//                S2_MEM_ADDR: //Data flow during memory address computation
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //X
//                        RegDst      = 1'b0;      //X
//                        IorD        = 1'b0;      //X
//                        PCSrc       = 1'b0;      //X
//                        ALUSrcB     = 2'b10;     //10
//                        ALUSrcA     = 1'b1;      //1
//                        //Register Enables
//                        IRWrite     = 1'b0;      //0
//                        MemWrite    = 1'b0;      //0
//                        PCWrite     = 1'b0;      //0
//                        RegWrite    = 1'b0;      //0
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //00
//                    end
//                S3_MEM_READ:
//                    begin  
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //
//                        RegDst      = 1'b0;      //
//                        IorD        = 1'b1;      //1
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b00;     //
//                        ALUSrcA     = 1'b0;      //
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b0;      //
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //
//                    end
//                S4_MEM_WRITE_BACK:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b1;      //1
//                        RegDst      = 1'b0;      //0
//                        IorD        = 1'b0;      //
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b00;     //
//                        ALUSrcA     = 1'b0;      //
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b1;      //1
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //
//                    end
//                S5_MEM_WRITE:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //
//                        RegDst      = 1'b0;      //
//                        IorD        = 1'b1;      //1
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b00;     //
//                        ALUSrcA     = 1'b0;      //
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b1;      //1
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b0;      //
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //
//                    end
//                S6_EXECUTE:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //
//                        RegDst      = 1'b0;      //
//                        IorD        = 1'b0;      //
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b00;     //00
//                        ALUSrcA     = 1'b1;      //1
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b0;      //
//                        //To ALU Decoder
//                        ALUOp       = 2'b10;     //10
//                    end
//                S7_ALU_WRITE_BACK:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //0
//                        RegDst      = 1'b1;      //1
//                        IorD        = 1'b0;      //
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b00;     //
//                        ALUSrcA     = 1'b0;      //
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b1;      //
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //
//                    end
//                S9_ADDI_EXECUTE:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //
//                        RegDst      = 1'b0;      //
//                        IorD        = 1'b0;      //
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b10;     //10
//                        ALUSrcA     = 1'b1;      //1
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b0;      //
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //0
//                    end
//                S10_ADDI_WRITE_BACK:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //0
//                        RegDst      = 1'b0;      //0
//                        IorD        = 1'b0;      //
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b00;     //
//                        ALUSrcA     = 1'b0;      //
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b1;      //1
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //
//							end
//                S11_ANDI_EXECUTE:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //
//                        RegDst      = 1'b0;      //
//                        IorD        = 1'b0;      //
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b11;     //Toma el zeroExtend_w
//                        ALUSrcA     = 1'b1;      //1
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b0;      //
//                        //To ALU Decoder
//                        ALUOp       = 2'b01;     //10 para tomar AND
//                    end
//                S12_ANDI_WRITE_BACK:
//                    begin
//                        //Multiplexer Selects
//                        MemtoReg    = 1'b0;      //0
//                        RegDst      = 1'b0;      //0
//                        IorD        = 1'b0;      //
//                        PCSrc       = 1'b0;      //
//                        ALUSrcB     = 2'b00;     //
//                        ALUSrcA     = 1'b0;      //
//                        //Register Enables
//                        IRWrite     = 1'b0;      //
//                        MemWrite    = 1'b0;      //
//                        PCWrite     = 1'b0;      //
//                        RegWrite    = 1'b1;      //1
//                        //To ALU Decoder
//                        ALUOp       = 2'b00;     //
//                    end
        endcase
    end

// *** ALU Decoder ***

always @(posedge clk) 
    begin
        if(rst)
            ALUFunctions_o <= 3'b000;       
        else
            case (funct)
					ADD_FN:
						if((funct7 == 6'h01) & (opCode == R_Type))
                    ALUFunctions_o <= 3'b101;
						 else
                    ALUFunctions_o <= 3'b010;
					SUB_FN:
                    ALUFunctions_o <= 3'b110;
					AND_FN:
                    ALUFunctions_o <= 3'b000;
					OR_FN:
                    ALUFunctions_o <= 3'b001;
					SLL_FN:
                    ALUFunctions_o <= 3'b111;
					SRL_FN:
                    ALUFunctions_o <= 3'b011;
					SLT_FN:
                    ALUFunctions_o <= 3'b100;
					SLTU_FN:
                    ALUFunctions_o <= 3'b100;
                default: 
                    ALUFunctions_o <= 3'b010;
            endcase
    end

always @(ALUOp) 
    begin
        case (ALUOp)
            3'b000:
                ALUControl <= 3'b010;
            3'b001:
                ALUControl <= 3'b110;
            3'b010:
                ALUControl <= ALUFunctions_o;
            3'b011:
                ALUControl <= 3'b011;
        endcase
    end
    
endmodule
