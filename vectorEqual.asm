#>>>>>>>>>>>>>>>>>>>> TEST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		.data
v1:		.asciiz "ABCD"
v2:		.asciiz "ABCD"
		.text
	la $a0,v1
	la $a1,v2
	jal Iguales
	
	move $a0,$v0
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
#********************************************************
# Dado dos vectores se comprueba si son igual.		*
# $a0 --> Direccion del vector 1			*
# $a1 --> Direccion del vector 2			*
# $v0 --> 1 == si | 0 == No				*
#********************************************************
Iguales: addi $sp,$sp,12
	li $v0,0
	move $t0, $a0
	move $t1, $a1
	sw $ra,12($sp)
	sw $t0,0($sp)
	sw $t1,4($sp)
	
	jal Lenght
	move $t6,$v0 			# Primer vector
	sw $t6,8($sp)
	
	lw $t1,4($sp)
	move $a0,$t1
	jal Lenght
	move $t7,$v0 			# Segundo vector
	
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t6,8($sp)
	
	bne $t6,$t7, no_iguales
	
	li $t6,0
	# $t7 Va a ser el contador para el bucle
	
testigual:	lb $t2, 0($t0)
		lb $t3, 0($t1)
		bne $t2,$t3,no_iguales 
		
		addi $t0,$t0,1
		addi $t1,$t1,1
		addi $t6,$t6,1
		
		beq $t6,$t7,iguales
		j testigual
no_iguales: li $v0,0
	j fin_iguales
iguales: li $v0,1
	
fin_iguales: lw $ra,12($sp)
		jr $ra

# *******************************************************
#	FUNCION LONGITUD CADENA				*
# Dado un vector devuelve su longitud			*
# $a0 --> Vector					*
# $v0 --> Longitud					*
#******************************************************** 

Lenght:	li $t0,0		# Inicializa el contador		
	move $t1,$a0

bucle:	lb $t3,0($t1)		# Carga primer elemento del vector 		
 	beqz $t3,fin_lenght		# Si $t3 == 0(Caracter nulo) ramifico a fin
 	addi $t0,$t0,1		# Incrementa el contador
 	addi $t1,$t1,1		# Avanza una posicion en el vector
	j bucle			# Ramifico a bucle

fin_lenght: 	move $v0,$t0
	jr $ra	 