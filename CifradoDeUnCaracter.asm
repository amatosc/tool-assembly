#************************< Test >***********************
			.data	
clavePrivada: 		.asciiz "ZYXWVUTSRQPONMLKJIHGFEDCBA"		# Modificable, IMPORTANTE! -> Elementos Unicos
elemento: 		.asciiz	"a" 					# Codificado -> Y
posicionEntreDosPuntos_A:	.ascii	"A"					# Codigo ascii de la A
posicionEntreDosPuntos_B:	.ascii	"Z"					# Codigo ascii de la Z
nuevaLinea: 		.byte	10,0						# Caracter nueva linea

#************* >>TEXTOS<< ******************************
originalText: 		.asciiz 	"Original : "
codificadoText: 	.asciiz 	"Codificado : "
decodificadoText:	.asciiz 	"Decodificado : "
posicionText:		.asciiz 	"Posicion en el vector es : "


		.text
main:	lb $s0,elemento
	la $s1,clavePrivada	
	
#+++++++++++++++++++++++++++++++++++++++++ DEBUGING +++++++++++++++++++++++++++++++++++++++++++	
debugOriginal:	la $a0, originalText				# Imprime el texto original con un salto de linea
	li $v0,4						# Imprime el texto original con un salto de linea
	syscall 						# Imprime el texto original con un salto de linea
	la $a0, elemento					# Imprime el texto original con un salto de linea
	li $v0,4						# Imprime el texto original con un salto de linea
	syscall							# Imprime el texto original con un salto de linea
	la $a0, nuevaLinea					# Imprime el texto original con un salto de linea
	li $v0,4						# Imprime el texto original con un salto de linea
	syscall 						# Imprime el texto original con un salto de linea
#---------------------------------------- DEBUGING ----------------------------------------------

		
	move $a0, $s0			# Elemnto a codificar
	move $a1, $s1			# Clave privada en la que se basa el cifrado
	jal Codificar
	move $s2, $v0

#+++++++++++++++++++++++++++++++++++++++++ DEBUGING +++++++++++++++++++++++++++++++++++++++++++
debugCodificado:	la $a0, codificadoText		# Imprime el texto Codificado con un salto de linea
	li $v0,4					# Imprime el texto Codificado con un salto de linea
	syscall 					# Imprime el texto Codificado con un salto de linea
	move $a0, $s2					# Imprime el texto Codificado con un salto de linea
	li $v0,11					# Imprime el texto Codificado con un salto de linea
	syscall						# Imprime el texto Codificado con un salto de linea
	la $a0, nuevaLinea				# Imprime el texto Codificado con un salto de linea
	li $v0,4					# Imprime el texto Codificado con un salto de linea
	syscall 					# Imprime el texto Codificado con un salto de linea
#---------------------------------------- DEBUGING ----------------------------------------------	

	move $a0,$s2
	move $a1,$s1
	jal Decodificar
	move $s2, $v0
	
#+++++++++++++++++++++++++++++++++++++++++ DEBUGING +++++++++++++++++++++++++++++++++++++++++++	
debugDecodificado:	la $a0, decodificadoText			# Imprime el texto Decodificado con un salto de linea
	li $v0,4							# Imprime el texto Decodificado con un salto de linea
	syscall 							# Imprime el texto Decodificado con un salto de linea
	move $a0, $s2							# Imprime el texto Decodificado con un salto de linea
	li $v0,11							# Imprime el texto Decodificado con un salto de linea
	syscall								# Imprime el texto Decodificado con un salto de linea
	la $a0, nuevaLinea						# Imprime el texto Decodificado con un salto de linea
	li $v0,4							# Imprime el texto Decodificado con un salto de linea
	syscall 							# Imprime el texto Decodificado con un salto de linea
#---------------------------------------- DEBUGING ----------------------------------------------	
	  
	li $v0,10
	syscall 
	
# *******************************************************************************
#			FUNCION CODIFICADORA 					*
# Dado un caractar devuelve su codificado basado en una clave			*
# publica.									*
# Se necesita que esten Definidas las etiquetas	(Limite clave privada)		*
# 	----> posicionEntreDosPuntos_A (Limite inferior)			*
# 	----> posicionEntreDosPuntos_B (Limite superior)			*
#										*
# $a0 --> Caracter a procesar							*
# $a1 --> Direccion a la clave							*
# $v0 --> Resultado (Byte)							*
#********************************************************************************

Codificar:	addi $sp,$sp, -16		# Reservo 4 palabras 
						
	sw $ra, 12($sp)				# Almaceno en memoria los datos que ya tenia
	sw $a1, 8($sp)				# Almaceno en memoria los datos que ya tenia
	sw $a0, 4($sp)				# Almaceno en memoria los datos que ya tenia
	
	move $a2,$a0
	lb $a0, posicionEntreDosPuntos_A
	lb $a1, posicionEntreDosPuntos_B
	
	jal PosicionEntreDosPuntos
	move $t0,$v0			# Guardo la poscion devuelta por la foncion
					# Rescato elelemtos de la pila
							
	lw $ra, 12($sp)			# Recupera los datos de la pila
	lw $a1, 8($sp)			# Recupera los datos de la pila
	lw $a0, 4($sp)			# Recupera los datos de la pila
	
	beq $t0,-1,desconocido 		# Si el caracter no es reconocido se devuelve el mismo
		

testMain:	la $t3,0($a1)			# Carga de la clave
	add $t3,$t3,$t0				# Suma desplazamiento
	j limpia
	
desconocido: move $t3, $a0		# Si el caracter no esta en la clave simplemente lo devuelvo
	j fin_codifica	
	
limpia: lb $t3, 0($t3)				
	 
fin_codifica: 	move $v0,$t3
	jr $ra

# *******************************************************************************
#			FUNCION DECODIFICADORA 					*
# Dado un caractar codificado lo decodifica basado en la clave			*
# privada.						 			*
# Se necesita que esten Definidas las etiquetas	(Limites clave privada)		*
# 	----> posicionEntreDosPuntos_A (Limite inferior)			*
# 	----> posicionEntreDosPuntos_B (Limite superior)			*
#										*
# $a0 --> Caracter a procesar							*
# $a1 --> Direccion a la clave							*
# $v0 --> Resultado (Byte)							*
#********************************************************************************

Decodificar:	addi $sp,$sp, -16		# Reservo 4 palabras 
						
	sw $ra, 12($sp)				# Almaceno en memoria los datos que ya tenia
	sw $a1, 8($sp)				# Almaceno en memoria los datos que ya tenia (Direccion a la clave)
	sw $a0, 4($sp)				# Almaceno en memoria los datos que ya tenia (Caracter)
	
	move $a0, $a1
	jal Lenght
	
	lw $a2, 4($sp)			# Elemento 
	move $a0,$a1			# Direccion de la clave (Vector)
	move $a1,$v0			# Longitud del vector
	jal Posicionenvector
	move $t7, $v0
	
	beq $t7,-1, decodifica_desconocido
	
	lb $t0, posicionEntreDosPuntos_A	# Limite inferior de la clave privada
	lb $t1, posicionEntreDosPuntos_B	# Limite superior de la clave privada
	li $t6,0				# Contador
	j genera				
	
decodifica_desconocido: 	lw $t0,4($sp)
	j fin_decodifica

genera:	add $t0,,$t0,$t7
		
fin_decodifica: 	lw $ra, 12($sp)
	move $v0,$t0
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
	
#************************< Posicion en Vector >*********************************
# Dado un vector y un elemnto la funcion devolvera la posicion de 		*
# de dicho elemnto en el vector. HAY QUE TENER EN CUENTA QUE EL VECTOR 		*
# ES DE ELEMENTOS UNICOS. ¡¡EL VECTOR EMPIEZA EN 0(ZERO)!!			*
# $a0 --> Direccion del Vector							*
# $a1 --> Lenght Vector								*
# $a2 --> Elemento								*
# $v0 --> [Posicion | -1(Elemnto no encontrado) ]				*
#********************************************************************************

Posicionenvector: 	li $t1,0		# Inicializo posicion

testEqual: 	lb $t0,0($a0)				# Carga la primera posicion del vector	
	beq  $a2,$t0,fin_posicionenvector
	addi $t1,$t1,1				# Incrementa el contador 
	addi $a0,$a0,1				# Adelanto una posicion en el vector
	beq $t1,$a1,noEncontrado		# Si contador > lenght ramifica  a no encontrado
	j testEqual
	
noEncontrado: li $t1,-1

fin_posicionenvector: 	move $v0,$t1	
	jr $ra

#******************< Posicion entre dos Puntos >***********************
# $a0 -> Punto A (Limite inferior)
# $a1 -> Punto B (Limite superior)
# $a2 -> X Elento a buscar
# $v0 -> Devuelve la poscion (-1 si no lo encuentra)
#*********************************************************************
PosicionEntreDosPuntos: li $t0,0		# Contador de posicones
	move $t1,$a0				# Limite Inferior
	move $t7,$a1				# Limite Superior
	
test:	beq  $a2,$t1,fin_posicionEntreDosPuntos
	addi $t1,$t1,1
	addi $t0,$t0,1
	ble $t1,$t7, test
	li $t0,-1
	
fin_posicionEntreDosPuntos: move $v0,$t0
	jr $ra
