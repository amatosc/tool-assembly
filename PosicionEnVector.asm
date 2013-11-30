#*******************< Test > ***********************************
		.data 
str: 		.ascii "GDFC"
lenght: 	.word 4
elemento: 	.ascii "C"

		.text
main: 	la $s0,str
	lw $s1,lenght
	lb $s2,elemento
	
	move $a0, $s0			# Vector
	move $a1, $s1			# Lenght
	move $a2, $s2			# Elemnto
	
	jal posicionenvector
	move $a0,$v0
	li $v0,1
	syscall 
	
	li $v0,10
	syscall
	
#************************< Posicion en Vector >*********************************
# Dado un vector y un elemnto la funcion devolvera la posicion de 		*
# de dicho elemnto en el vector. HAY QUE TENER EN CUENTA QUE EL VECTOR 		*
# ES DE ELEMENTOS UNICOS. ¡¡EL VECTOR EMPIEZA EN 0(ZERO)!!			*
# $a0 --> Direccion del Vector							*
# $a1 --> Lenght Vector								*
# $a2 --> Elemento								*
# $v0 --> [Posicion | -1(Elemnto no encontrado) ]				*
#********************************************************************************

posicionenvector: 	li $t1,0		# Inicializo posicion
	
testEqual: 	lb $t0,0($a0)				# Carga la primera posicion del vector	
	beq  $a2,$t0,fin
	addi $t1,$t1,1				# Incrementa el contador 
	addi $a0,$a0,1				# Adelanto una posicion en el vector
	beq $t1,$a1,noEncontrado		# Si contador > lenght ramifica  a no encontrado
	j testEqual
	
noEncontrado: li $t1,-1

fin: 	move $v0,$t1	
	jr $ra
