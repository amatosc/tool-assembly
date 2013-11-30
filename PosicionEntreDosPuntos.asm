#*********************>   TEST	<*************************************
		.data
elemento: 	.asciiz	"Z" 					# Elemento a buscar -> posicion 1
codificado:	.ascii 	""
decodificado:	.ascii	""
A:		.ascii	"A"					# Codigo ascii de la A
Z:		.ascii	"Z"					# Codigo ascii de la Z	
		
		.text
	lb $a0,A
	lb $a1,Z
	lb $a2,elemento
	jal posicionEntreDosPuntos
	
	move $a0,$v0
	li $v0,1
	syscall
	
	
	li $v0,10
	syscall 

#******************< Posicion entre dos Puntos >***********************
# $a0 -> Punto A (Limite inferior)
# $a1 -> Punto B (Limite superior)
# $a2 -> X Elento a buscar
# $v0 -> Devuelve la poscion (1- si no lo encuentra)
#*********************************************************************
posicionEntreDosPuntos: li $t0,0		# Contador de posicones
	move $t1,$a0				# Limite Inferior
	move $t7,$a1				# Limite Superior
	
test:	beq  $a2,$t1,fin_posicionEntreDosPuntos
	addi $t1,$t1,1
	addi $t0,$t0,1
	ble $t1,$t7, test
	li $t0,-1
	
fin_posicionEntreDosPuntos: move $v0,$t0
	jr $ra
