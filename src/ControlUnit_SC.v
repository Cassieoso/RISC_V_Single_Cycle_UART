module ControlUnit_SC (
    input clk, rst,
    input [6:0] opCode,
	 output reg Branch,
	 output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
	 output reg ALUSrc,
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
    output reg [2:0] ALUOp
);

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


always @*
	begin
		if (rst) 
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrc			=	1'b0;
						RegWrite			=	1'b0;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b0;
						immediateSel	=	3'b000;
						ALUOp				=	3'b000;
					end
		else 
		case (opCode)
            R_Type:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0; //No esta conectado a nada
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrc			=	1'b0;
						RegWrite			=	1'b1;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b1;
						immediateSel	=	3'b000;
						ALUOp				=	3'b010;
					end
				default:
					begin
						Branch			=	1'b0;
						MemRead			=	1'b0;
						MemtoReg			=	1'b0;
						MemWrite			=	1'b0;
						ALUSrc			=	1'b0;
						RegWrite			=	1'b0;
						HADDR_Sel		=	1'b0;
						RegDst			=	1'b0;
						immediateSel	=	3'b000;
						ALUOp				=	3'b000;
					end
	endcase	 
	end
endmodule