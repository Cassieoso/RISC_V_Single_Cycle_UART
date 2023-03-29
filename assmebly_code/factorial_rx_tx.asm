

.text
		auipc s0, 0xFC10
		addi s1, s0, 0x002C #UART_TX
		addi s2, s0, 0x0030 #UART_RX
		addi s3, s0, 0x0034 #UART_BUSY
		addi s5, s0, 0x0038 #UART_READY
		#addi t1, t1, 1
		#sw t1, 0(s3)
	main:
		addi s4, s4, 0x0003
		#li a2, 3
		#addi a2, zero, 3
	loop_rx:
		lw s6, 0(s5) #Guarda lo que hay en UART_READY para ver si nos llego algo de rx
		beq s6, zero, loop_rx #Se queda esperando mientras llega algo
		lw a2, 0(s2) #Si nos llego un valor por rx, guardalo en el register file para calcular el factorial
		jal factorial
		#j exit
		jal exit
	
	factorial:
		slti t0, a2, 1
		beq t0, zero, loop
		addi a0, zero, 1
		#jr ra
		jalr ra, 0
		
	loop:
		addi sp, sp, -8
		sw ra, 4(sp)
		sw a2, 0(sp)
		addi a2, a2, -1
		jal factorial
		lw a2, 0(sp)
		lw ra, 4(sp)
		addi sp, sp, 8
		mul a0, a2, a0
		#jr ra
		jalr ra, 0
	exit:
		sw a0, 0(s1) #Guarda el resultado en 0x1001002C que es el UART_Tx
	UART:
		lw t1, 0(s3) #Guarda lo que hay en 0x10010034 que es el UART_BUSY en t1
		bne t1, zero, UART #Si no ha terminado, sigue preguntando
		slli a0,a0,8 #Hace shift left de 8 bits
		sw a0, 0(s1) #Guarda el resultado en 0x1001002C que es el UART_Tx
		addi s4,s4,-1
		bne s4, zero, UART
	goback:
		lw t1, 0(s3) #Guarda lo que hay en 0x10010034 que es el UART_BUSY en t1
		bne t1, zero, goback #Si no ha terminado, sigue preguntando
		jal main
		