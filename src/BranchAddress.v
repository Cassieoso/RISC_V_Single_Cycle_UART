module BranchAddress (
    input clock, reset, enable,
    input [4:0]immediate1107,
	 input [6:0]immediate3125,
    output reg [31:0] branch
    );
    
always @*
    begin
        if(reset)
            branch <= 32'b0;
        else
            if(enable)
                branch <= {19'h0,immediate3125[6],immediate1107[0],immediate3125[5:0],immediate1107[4:1],1'b0} - 1'b1;
            else
                branch <= branch;
    end

endmodule