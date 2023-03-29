module ImmediateDecode (
    input [31:0] instruction,
	 input [2:0] sel,
    output reg [31:0] immediate
    );


localparam I_TYPE			= 3'b000;
localparam S_TYPE			= 3'b001;
localparam B_TYPE			= 3'b010;
localparam U_TYPE			= 3'b011;
localparam J_TYPE			= 3'b100;
localparam U_TYPE_SLL	= 3'b101;
    
    always @*
    begin
        case(sel)
        I_TYPE:
           immediate <= {{20{instruction[31]}},instruction[31:20]};
        S_TYPE:
           immediate <= {20'h0,instruction[31:25],instruction[11:7]};
        B_TYPE:
           immediate <= {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} - 3'h4;
        U_TYPE:
           immediate <= {12'h0,instruction[31:12]};
        J_TYPE:
           immediate <= {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0} - 3'h4;
        U_TYPE_SLL:
           immediate <= ({12'h0,instruction[31:12]} << 'hC) - 3'h4;
        default: 
           immediate <= {19'h0,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} - 3'h4;
        endcase
    end

endmodule