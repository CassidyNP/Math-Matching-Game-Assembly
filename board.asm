.data
	newLine:	.asciiz		"\n"
	divider:	.asciiz 	"| "
	charZero:	.asciiz		"0"
	space:		.asciiz		" "
	timesFiveMsg: 	.asciiz 	" * 5"
	
.text
.globl initializeBoard
.globl displayBoard

initializeBoard:
	li $t0, 0			# set the index to 0
	
initializeLoop:
	sb $zero, matched($t0)		# set matched entry to zero(since we are starting)
	addi $t0, $t0, 4
	li $t1, 64			# 16 * 4
	bne $t0, $t1, initializeLoop	# loop until all entires are set to 0
	
	jr $ra				# return to the caller
	
displayBoard:
	li $t0, 1			# card number starrs at 1
	li $t1, 0			# match array index starts at 0			 
	li $t9, 0			# this is to calculate columns
	
	
displayLoop:

	#check if we have printed all 16 cards
	li $t6, 17			# set it to 17
	beq $t0, $t6, exitDisplay	# if it is 17 then exit
	
	#check if the card is matched
	lb $t3, matched($t1)		#load matched status for the current card
	beq $t3, 1, printZero		#if it is matched then go to printZero function to print
	
	#print the card number if it is not matched
	li $v0, 1			#SysPrintInt
	move $a0, $t0			#load current card number
	syscall
	
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	# another space for single digit numbers
	blt $t0, 10, addSpace
	
	j printDivider			#jump to print the divider
	
addSpace:
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	j printDivider
	
# This "printZero" is a function that was used when showing a 0 when the card was match but now the shows the card value
printZero:
	li $t5, 12
	
	mul $t7, $t1, 1
	lw $t8, cards($t7)
	
	ble $t8, $t5, displayEquation 	# If index =< 12, show equation

	# print the answer
	li $v0, 1
	move $a0, $t8
	syscall
	
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 

	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	j printDivider
	
displayEquation:
	li $v0, 1
	move $a0, $t8
	syscall

	li $v0, 4                     # Print " * 5"
    	la $a0, timesFiveMsg
    	syscall
    	
    	li $v0, 4			#SysPrintString
	la $a0, space
	syscall 
	
	j printDivider

printDivider:
	
	#print divider between the cards
	li $v0, 4			#SysPrintString
	la $a0, divider
	syscall 
	
	#prepare for the next card
	addi $t0, $t0, 1		# increment card number
	addi $t1, $t1, 4		# matched array index
	addi $t9, $t9, 1		# increment column counter
	
	# Print a new line after every 4 cards
    	rem $t4, $t9, 4			# chose $t9 the match index since it starts with 0
    	beqz $t4, newLinePrint
    	
    	j displayLoop

newLinePrint:
    	# Print new line after every 4 cards
    	li $v0, 4
    	la $a0, newLine
    	syscall

	j displayLoop
	
exitDisplay:
	jr $ra
