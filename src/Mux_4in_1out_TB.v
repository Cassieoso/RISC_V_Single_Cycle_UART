module Mux_4in_1out_TB ();
reg clk;
reg [31:0] A,B,C,D;   
reg enable;
reg reset;    
reg [2:0] sel;
wire [31:0] Q;

Mux_4in_1out #(.LENGTH(32)) Mux_2in_1out_4(       //RegisterFile to ALU
    .clk(clk),
    .rst(reset),
    .enable(enable),                    
    .A(A),
    .B(B),                        
    .C(C),
    .D(D), 
    .sel(sel),                       //This sel has to come from FSM 
    .Q(Q)
    );
	 
initial
	begin
	clk = 1'b1;
	A = 32'h00000001;
	B = 32'h00000002;
	C = 32'h00000003;
	D = 32'h00000004;
	enable = 1'b1;
	sel = 3'b1;
	reset = 1'b0;
	end
	
always
	begin
	#10 clk = ~clk;
	end
	
endmodule
	