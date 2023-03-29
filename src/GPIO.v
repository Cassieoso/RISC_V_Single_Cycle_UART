module GPIO (
    input clk, reset, enable_LEDS, enable_SWITCHES,
    input [7:0] gpio_port_in,
	 input [31:0] HWDATA,
	 output reg [7:0] gpio_port_out,
	 output reg [31:0] HRDATA
    );
	 
    
localparam LEDS = 'h10010024;
localparam SWITCHES = 'h10010028;

	 
always @(posedge clk)
		begin
       if(reset)
			begin
            gpio_port_out <= 7'b0;
					HRDATA <= 7'b0;
			end
			else
			if(enable_LEDS)
//				begin
				gpio_port_out <= HWDATA[7:0];
//				HRDATA <= HRDATA;
//				end
			else if(enable_SWITCHES)
//				begin
				HRDATA <= {{24{1'b0}},gpio_port_in};
//				gpio_port_out <= gpio_port_out;
//				end
			else
				begin
				gpio_port_out <= gpio_port_out;
				HRDATA <= HRDATA;
				end

		end

endmodule