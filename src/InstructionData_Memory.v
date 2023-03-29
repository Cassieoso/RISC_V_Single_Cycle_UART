// Quartus II Verilog Template
// Single port RAM with single read/write address 
module InstructionData_Memory #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 7)(	
    input [(ADDR_WIDTH-1):0] addr,
    input [(DATA_WIDTH-1):0] data,
	input we, clk,
	output [(DATA_WIDTH-1):0]RD 
    );
// Declare the RAM array
reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	initial
	begin
		$readmemh("Instruction_set.txt", ram);
	end

always @ (posedge clk)
	begin
		// Write
		if (we)
			ram[addr] <= data;
	end
// Reading continuously
assign RD = ram[addr];
endmodule
