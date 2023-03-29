module register #(parameter LENGTH_v = 8)(
	 //Entradas
        input clock,reset,enable,
        input [LENGTH_v-1:0]D,
	 //Salidas
        output reg [LENGTH_v-1:0]Q
    );

//Se activa en el flanco positivo del clock o del reset
always @(posedge clock, posedge reset ) 
    begin
	 //En reset, resetear el valor de Q (puede ser las entradas B, A por ejemplo)
        if (reset) 
            Q <= {LENGTH_v{1'b0}};
	 //Si se activo el always y fue por el clock
        else
		  //Si es enable, se pasa el valor al registro para poder ser utilizado en la ALU
            if (enable)
                Q <= D;
		 //Si no se apreto el boton de enable, el registro sigue teniendo el mismo valor de antes.
            else
                Q <= Q;
    end
endmodule