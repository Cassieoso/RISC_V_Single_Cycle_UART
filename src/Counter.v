module Counter #(parameter n = 4)(
    input clk,
    input rst,
    input enable,
    output reg [n-1:0] Q
    );

 always @(posedge rst, posedge clk) 
    begin
        if (rst)
            Q <= {n{1'b0}};
        else
            if (enable)
				//Va aumentando el contador 1 en 1
                Q <= Q + 1'b1;
            else
                Q <= Q;
    end 
endmodule