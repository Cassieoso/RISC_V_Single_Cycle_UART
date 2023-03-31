module ALU_Control (
	input rst,
	input [2:0] ALUOp,
	input [2:0] funct,
	input [6:0] funct7,
	input [6:0] opCode,
	output reg [2:0] ALUControl
);

localparam R_Type = 7'b0110011;
localparam ADD_FN	= 3'b000;
localparam SUB_FN	= 3'b100;
localparam AND_FN	= 3'b111;
localparam OR_FN	= 3'b110;
localparam SLL_FN	= 3'b001;
localparam SRL_FN	= 3'b101;
localparam SLT_FN	= 3'b010;
localparam SLTU_FN = 3'b011;
reg [2:0] ALUFunctions_o;

always @*
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