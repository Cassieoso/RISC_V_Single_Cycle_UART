module ControlUnit_SC (
    input clk, rst,
    input [6:0] opCode,
	 input [2:0] funct,
	 output reg Branch,
	 output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
	 output reg ALUSrcA,
	 output reg ALUSrcB,
    output reg RegWrite,
	 output reg HADDR_Sel,
	 output reg RegDst,
//    output reg RegDst,
//    output reg IorD,
//    output reg PCSrc,
//    output reg [1:0] ALUSrcB,
//    output reg ALUSrcA,
//    output reg IRWrite,
//   output reg PCWrite,
//	 output reg BranchEQ,
//	 output reg BranchNE,
	 output reg [2:0] immediateSel,
    output reg [2:0] ALUOp,
	 output reg JalFunct
);

localparam B_Type = 7'b1100011;
localparam JAL = 7'b1101111;
localparam I_Type = 7'b0010011;
localparam S_Type = 7'b0100011;
localparam R_Type = 7'b0110011;
localparam BEQ = 3'b000;
localparam BNE = 3'b001;
localparam JALR = 7'b1100111;
localparam AUIPC = 7'b0010111;
localparam LW	= 7'b0000011;
localparam SW	=	3'b010;


always @*
	begin
		if (rst) 
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b0;
						ALUSrcB			=	1'b0;
						RegWrite			=	1'b0;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b0;
						immediateSel	=	3'b000;
						ALUOp				=	3'b000;
						JalFunct			=	1'b0;
					end
		else 
		case (opCode)
            R_Type:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0; //No esta conectado a nada
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b1;	//Selecciona el RD1
						ALUSrcB			=	1'b0;	//Y el RD2
						RegWrite			=	1'b1;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b1;
						immediateSel	=	3'b000;
						ALUOp				=	3'b010;
						JalFunct			=	1'b0;
					end
            I_Type:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0; //No esta conectado a nada
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b1;		//Seleccina el RD1
						ALUSrcB			=	1'b1;		//Selecciona el immediate
						RegWrite			=	1'b1;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b1;
						immediateSel	=	3'b000;	//Selecciona el de tipo I
						ALUOp				=	3'b010;	//Que seleccione dependiendo del funct
						JalFunct			=	1'b0;
					end
				AUIPC:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;	//No esta conectado a nada
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b0;	//Selecciona el PC
						ALUSrcB			=	1'b1;	//Selecciona el immediate
						RegWrite			=	1'b1;	//Para que escriba en el register file
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b1;	//Guarda en rd
						immediateSel	=	3'b101;	//U Type con shift
						ALUOp				=	3'b000;	//Para que sume
						JalFunct			=	1'b0;
					end
				LW:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;
						MemtoReg			=	1'b1;	//Para seleccionar la salida de la memoria de datos
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b1;	//Selecciona RD1
						ALUSrcB			=	1'b1;	//Y el immediate
						RegWrite			=	1'b1;	//Habilita la escritura en el register file
						HADDR_Sel		=	1'b1;	//Para seleccionar la direccion de memoria y no la del PC
						RegDst			=	1'b1;	//Lo escribe en rd
						immediateSel	=	3'b000;	//I_Type
						ALUOp				=	3'b000;	//Y los suma
						JalFunct			=	1'b0;
					end
				B_Type:
					if(funct == BEQ)
					begin
						Branch			=	1'b1;	//Si es un branch
						MemRead			=	1'b0;
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b1;	//Elige rd1 del register file
						ALUSrcB			=	1'b0;	//Y rd2 del register file
						RegWrite			=	1'b0;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b0;
						immediateSel	=	3'b010;	//Para B Type
						ALUOp				=	3'b110;	//Para restar y ver si son iguales
						JalFunct			=	1'b0;
					end
					else
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b0;
						ALUSrcB			=	1'b0;
						RegWrite			=	1'b0;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b0;
						immediateSel	=	3'b000;
						ALUOp				=	3'b000;
						JalFunct			=	1'b0;
					end
				JAL:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b0;	//Para el PC
						ALUSrcB			=	1'b1;	//Para el immediate
						RegWrite			=	1'b0;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b0;
						immediateSel	=	3'b100;	//Para J Type
						ALUOp				=	3'b000;	//Para sumar
						JalFunct			=	1'b1;		//Es funcion Jal
					end
				default:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrcA			=	1'b0;
						ALUSrcB			=	1'b0;
						RegWrite			=	1'b0;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b0;
						immediateSel	=	3'b000;
						ALUOp				=	3'b000;
						JalFunct			=	1'b0;
					end
	endcase	 
	end
endmodule