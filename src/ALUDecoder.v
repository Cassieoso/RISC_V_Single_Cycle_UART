module ALUDecoder (
    input clk, rst,
	 input [6:0] opCode,
    input [5:0]funct,
	 input [6:0] funct7,
    input [1:0]ALUOp,
    output reg [2:0]ALUControl
    );

localparam ADD_FN  = 5'b10000;
localparam SUB_FN  = 3'b001;
localparam AND_FN  = 3'b010;
localparam OR_FN   = 3'b011;
localparam SLT_FN  = 3'b100;
localparam R_Type = 7'b0110011;

reg [2:0] ALUFunctions_o;

always @(posedge clk, posedge rst) 
    begin
        if(rst)
            ALUControl <= 3'b000;
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
                SLT_FN:
                    ALUFunctions_o <= 3'b111;
                default: 
                    ALUFunctions_o <= 3'b010;
            endcase
    end

always @(ALUOp) 
    begin
        case (ALUOp)
            2'b00:
                ALUControl <= 3'b010;
            2'b01:
                ALUControl <= 3'b110;
            2'b10:
                ALUControl <= ALUFunctions_o;
            2'b11:
                ALUControl <= ALUFunctions_o;
        endcase
    end
    
endmodule