module ALU_TB ();
reg clk;
reg [31:0] A,B;           
reg [2:0] ALU_Sel;
reg [4:0] shamt;
wire [31:0] ALU_Out;

ALU #(.LENGTH(32)) ALU_TOP(       
    .clk(clk),
    .ALU_Sel(ALU_Sel),               //??
    .A(A),                   //This A has to come from ALU
    .B(B),                         
    .shamt(shamt),                 //This sel has to come from FSM 
    .ALU_Out(ALU_Out)
    );

initial
	begin
	clk = 1'b0;
	A = 32'h00000001;
	B = 32'h00000002;
	ALU_Sel = 3'b010;
	shamt = 5'b00001;
	end
	
always
	begin
	#10 clk = ~clk;
	end
	
endmodule
	