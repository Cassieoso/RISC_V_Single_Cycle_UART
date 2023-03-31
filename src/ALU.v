module ALU #(parameter LENGTH = 5)(
input clk,
input signed [LENGTH-1:0] A,B,                  
input [2:0] ALU_Sel,
input [4:0] shamt,
output reg [LENGTH-1:0] ALU_Out,
output reg zero
    );


	 
localparam AND					= 3'b000;
localparam OR					= 3'b001;
localparam ADD					= 3'b010;
localparam SUB					= 3'b110;
localparam SHIFT_LEFT		= 3'b111;
localparam SHIFT_RIGHT		= 3'b011;
localparam SET_LESS_THAN	= 3'b100;
localparam MUL					= 3'b101;


    always @*
    begin
        case(ALU_Sel)
        AND:
           ALU_Out = A & B;
        OR:
           ALU_Out = A | B;
        ADD:
           ALU_Out = A + B;
        SUB:
           ALU_Out = A - B;
        SHIFT_LEFT:
           ALU_Out = A << B[4:0];
        SHIFT_RIGHT:
           ALU_Out = A >> B;
        SET_LESS_THAN:
           ALU_Out = A < B;
        MUL:
           ALU_Out = A * B;
        default: 
           ALU_Out = 'h0; 
        endcase
			
			zero = (ALU_Out == 0)? 1:0;
    end

endmodule