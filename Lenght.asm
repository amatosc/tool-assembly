#*********************<	TEST  > ******************
		
		.data
text: 		.ascii "Hola mundo" 	# Lenght = 10

		.text
main:	la $a0,text
	jal lenght
	
	move $s0,$v0
	move $a0,$s0
	li $v0,1
	syscall
	
	li $v0,10
	syscall

# *******************************************************
#	FUNCION LONGITUD CADENA				*
# Dado un vector devuelve su longitud			*
# $a0 --> Vector					*
# $v0 --> Longitud					*
#******************************************************** 

lenght:	li $t0,0		# Inicializa el contador		
	move $t1,$a0

bucle:	lb $t3,0($t1)		# Carga primer elemento del vector 		
 	beqz $t3,fin		# Si $t3 == 0(Caracter nulo) ramifico a fin
 	addi $t0,$t0,1		# Incrementa el contador
 	addi $t1,$t1,1		# Avanza una posicion en el vector
	j bucle			# Ramifico a bucle

fin: 	move $v0,$t0
	jr $ra 
