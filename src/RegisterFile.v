module RegisterFile #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)(
	input [(ADDR_WIDTH-1):0] A1, A2, A3,    //Addres Directions
	input [(DATA_WIDTH-1):0] WD3,           //Input Data
	input WE3,                              //Enablement
	input clk,reset,
	output [(DATA_WIDTH-1):0] RD1,RD2   //Output Data
	);

// RAM Variable Declaration
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	initial
	begin
		$readmemh("Data.txt", ram);
	end

always @ (posedge clk)
  begin
    if (WE3) 
        ram[A3] <= WD3;
  end

assign RD1 = ram[A1];
assign RD2 = ram[A2];

endmodule
