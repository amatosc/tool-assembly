		.data 
text: 		.ascii "ABCD"
newT:		.space 10
nuevaLinea:	.byte	10,0
cNulo:		.byte '\n'

		.text
	la $t0,text
	lb $t1, cNulo
	li $t2,4
	
	la $t3,newT
	li $t7,0
	
a:	lb $t4,0($t0)
	sb $t4,0($t3)
	addi $t0,$t0,1
	addi $t3,$t3,1
	addi $t7,$t7,1
	blt $t7,$t2,a
	
	#la $t3,newT
	#addi $t3,$t3,1
	sb $t1,0($t3)

	li $v0,10
	syscall
