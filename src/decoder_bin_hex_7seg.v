//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer:  Cuauhtemoc Aguilera
// Binary to 7 segments Display: Common Anode
//////////////////////////////////////////////////////////////////////////////////
module decoder_bin_hex_7seg(
    input w,
    input x,
    input y,
    input z,
    output seg_a,
    output seg_b,
    output seg_c,
    output seg_d,
    output seg_e,
    output seg_f,
    output seg_g
   );
//				     abc_defg
parameter cero  = 7'b000_0001;
parameter uno   = 7'b100_1111;
parameter dos   = 7'b001_0010;
parameter tres  = 7'b000_0110;
parameter cuatro= 7'b100_1100;
parameter cinco = 7'b010_0100;
parameter seis  = 7'b010_0000;
parameter siete = 7'b000_1111;
parameter ocho  = 7'b000_0000;
parameter nueve = 7'b000_0100;
parameter A     = 7'b000_1000;
parameter b     = 7'b110_0000;
parameter C     = 7'b011_0001;
parameter d     = 7'b100_0010;
parameter E     = 7'b011_0000;
parameter F     = 7'b011_1000;

reg [6:0]segmentos;
always @(w,x,y,z)
	begin
	 case ({w,x,y,z})
	  4'h0: segmentos = cero;
	  4'h1: segmentos = uno;
	  4'h2: segmentos = dos;
	  4'h3: segmentos = tres;
	  4'h4: segmentos = cuatro;
	  4'h5: segmentos = cinco;
	  4'h6: segmentos = seis;
	  4'h7: segmentos = siete;
	  4'h8: segmentos = ocho;
	  4'h9: segmentos = nueve;
	  4'hA: segmentos = A;
	  4'hB: segmentos = b;
	  4'hC: segmentos = C;
	  4'hD: segmentos = d;
	  4'hE: segmentos = E;
	  4'hF: segmentos = F;
	  default: segmentos = 7'b1111110; // -	    
      endcase
	end
assign {seg_a, seg_b, seg_c, seg_d,
        seg_e, seg_f, seg_g} = segmentos;
endmodule  