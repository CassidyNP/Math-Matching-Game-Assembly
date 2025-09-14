.data

	correctMatch: .word 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0
	incorrectMatch: .word 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1
	win: .word 1, 1, 0, 0, 0, 1, 1,0,0,1, 1, 0, 0, 0, 1, 1

.text
.globl correctSound
.globl incorrectSound
.globl winSound

#for reference
#a0- pitch
#a1- time in ms
#a2-instrument
#a3- volume
winSound:
  	la $t8, win			# Load address of LOOP1
   	li $t2, 52 			#instrument
   	jal correctLoop
   
   	j gameWin
   
	
correctSound:
	la $t8, correctMatch 		# Load address of LOOP1
	li $t2, 114 			#instrument
	jal correctLoop
	j matchFound

incorrectSound:
	la $t8, incorrectMatch 	# Load address of LOOP2
	li $t2, 100 			#instrument
	jal incorrectLoop
	j incorrectPenalty
	
correctLoop:
	li $t7, 0  			# Initialize loop counter to 0
	li $t9, 16 			# The number of elements in the array (16 words in LOOP1)
	lw $t1, 0($t8)
	addiu $t8, $t8, 4 		# Increment play data
	addi $t7, $t7, 1 		#$t7 is used to verify the loop's end
	bne $0, $t1, playSound
	
	li $a0, 110
	li $v0, 32
	syscall 			#sleep syscall

incorrectLoop:

	lw $t1, 0($t8)
	addiu $t8, $t8, 4 		# Increment play data
	addi $t7, $t7, 1 		#$t7 is used to verify the loop's end
	bne $0, $t1, playSound
	li $a0, 127
	li $v0, 32
	syscall 			#sleep syscall


playSound:
	li $a0, 62
	# li $a1, 100
	beq $t2,114, matchDuration
	beq $t2,52, winDuration

	li $a1, 3000 			# 3 seconds, we are ignoring the actual time in terms of incrementing the time
	move $a2, $t2
	li $a3, 120
	la $v0, 33
	syscall 			#calls service 33, playing music

	jr $ra

matchDuration:
	li $a1, 2000 			# 3 seconds, we are ignoring the actual time in terms of incrementing the time
	move $a2, $t2
	li $a3, 120

	la $v0, 33
	syscall 			#calls service 33, playing music

	jr $ra

winDuration:
	li $a1, 5000 			# 3 seconds, we are ignoring the actual time in terms of incrementing the time
	move $a2, $t2
	li $a3, 120

	la $v0, 33
	syscall 			#calls service 33, playing music

	jr $ra


	




