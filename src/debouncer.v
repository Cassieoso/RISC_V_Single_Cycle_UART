// Company: ITESO
// Engineer: Cuauhtemoc Aguilera
//////////////////////////////////////////////////////////////////////////////////
module Debouncer(
    input clk,
    input nrst,
    input sw,
    output one_shot
    );


wire fin_delay_w, rst_out_w;
wire rst_w;

assign rst_w = ~nrst;

wire one_shot_w = one_shot;

wire [3:0]Counter_TOP_w;

FSM_Debouncer  fsm (
    .clk(clk), 
    .rst(rst_w), 
    .sw(sw), 
    .fin_delay(fin_delay_w),
	.rst_out(rst_out_w), 
    .one_shot(one_shot)     
    );

Delayer # (.YY(10)) delay_30ms ( 
        .clk(clk), 
        .rst(rst_out_w), 
        .enable(1'b1), 
        .iguales(fin_delay_w)    
        ); 
						  
endmodule
