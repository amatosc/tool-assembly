#******************** TEST ****************************
	.data
vector: .asciiz "ABZV"

	.text
	
	la $a0,vector
	
debugFirstE:	lb $a0, 0($a0)
	li $v0,11
	syscall
	
	li $v0,10
	syscall