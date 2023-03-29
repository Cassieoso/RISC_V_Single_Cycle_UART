module signExtend (
    input clock, reset, enable,
    input [15:0]extend,
    output reg [31:0]extended
    );
    
always @*
    begin
//		if(reset)
 //           extended <= 32'b0;
//        else
//            if(enable)
                extended <= {{16{extend[15]}},extend[15:0]};              
 //           else
//                extended <= extended;
    end

endmodule