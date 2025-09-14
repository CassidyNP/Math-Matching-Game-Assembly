.data
	# this is just some debug we used 
	debug:	.asciiz 	"\n-----------------this is an equation-----------\n"
	debug1: .asciiz		"\n-----------------this is an answer-----------\n"
	

.text

.globl checkMatch
.globl checkWin
.globl revealCard

# checkMatch: Checks if two chosen cards are a match
checkMatch:
    	# calculate the equation 
    	mul $s3, $s3, 5
    	
    	# check if the equation answer matches with the actual answer
   	beq $s4, $s3, cardsMatch      # If they match, go to cardsMatch

    	li $v0, 0                     # No match
    	jr $ra

cardsMatch:
    	li $v0, 1                     # Match found
    	sb $v0, matched($s1)          # Mark first card as matched with a 1

    	sb $v0, matched($s2)          # Mark second card as matched with a 1
    	
   	jr $ra

# checkWin: Checks if all pairs are matched
checkWin:
    	li $t0, 0                     # Start index
    	li $v0, 1                     # Assume all matched
winLoop:
    	lb $t1, matched($t0)          # Load matched status for card at index $t0
    	beqz $t1, notWin              # If any card is unmatched, go to notWin
    	addi $t0, $t0, 4              # Move to the next card
    	li $t2, 64                    # Total cards, memory 16 * 4
    	bne $t0, $t2, winLoop         # Loop until all cards are checked
    	jr $ra

notWin:
    	li $v0, 0                     # Not all matched
    	jr $ra

# revealCard: Displays the content of the chosen card, whether it's an equation or answer
revealCard:
	# move the card the user selected to $s0
	move $s0, $t0
	
	# calculate the correct index
	subi $s0, $s0, 1
	mul $s0, $s0, 4
	
	# get the correct value 
	lw $t4, cards($s0)
	
	# this is the biggest number from the equation set
	li $t5, 12
	
	
    	# Determine if it’s an equation or answer card (1-16 cards indexing)

    	ble $t4, $t5, getRightIndex  	# If index =< 12, get the index for the equation
    	j getRightIndexAnswer         # Otherwise, get the index for the answer
 
showEquation:	
	
   	lw $t2, cards($s1)        	# Load the card value
   
    	li $v0, 4                     # SysPrintString
    	la $a0, cardContainsMsg
    	syscall

    	li $v0, 1                     # SysPrintInt
    	move $a0, $t2
    	syscall

    	li $v0, 4                     # SysPrintString
    	la $a0, timesFiveEqualsMsg
    	syscall
    
    	jr $ra				# return to caller

getRightIndex:

	addi $t8, $t8, 1		# increment the counter for double same type
	move $s3, $t4			# move the value to $s3 for later
	move $s1, $s0			# save the index in $s1
	
	j showEquation
	
getRightIndexAnswer:

	addi $t6, $t6, 1		# increment to see if it is a double of the same card
	move $s4, $t4			# move the value to $s4 for late
	move $s2, $s0			# save the index in $s2
	
	j showAnswer
	
showAnswer:

	lw $t2, cards($s2)          	# Load card at this index

    	li $v0, 4                     # SysPrintString
    	la $a0, cardContainsMsg
    	syscall
   
    	li $v0, 1                     # SysPrintInt
    	move $a0, $t2
    	syscall
    
    	li $v0, 4			# SysPrintString
    	la $a0, newLine1
    	syscall
    
    	jr $ra				# return to caller
  
