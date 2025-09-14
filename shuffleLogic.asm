.data
	space1:	.asciiz	" "
.text
.globl shuffleCards

shuffleCards:
# Constants and array setup
	la $t4, cards          	# oad base address of cards
    	li $t2, 16                   	# number of elements in cards (16 cards)

shuffleStart:
    	li $s0, 15                   	# start from the last index of the array

shuffleLoop:
    	blt $s0, 1, doneShuffle     	# if index < 1, we are done

    	# generate random index between 0 and $s0 (inclusive)
    	li $a0, 0                   	# lower bound = 0
    	move $a1, $s0            
    	li $v0, 42                  	# syscall for random integer
    	syscall
    	rem $t6, $a0, $a1           	# ensure it is within the range [0, $s0] (inclusive)

   

    	# swap elements 
    	mul $t7, $s0, 4             	# byte offset 
    	add $t7, $t4, $t7           	# address of cards[$s0]
    	mul $t8, $t6, 4             	# byte offset for random index $t6
    	add $t8, $t4, $t8           	# address of cards[$t6]

    	lw $t9, 0($t7)              	# load cards[$s0]
    	lw $t5, 0($t8)              	# load cards[$t6]
    	sw $t5, 0($t7)              	# store cards[$t6] at cards[$s0]
    	sw $t9, 0($t8)              	# store cards[$s0] at cards[$t6]

    	addi $s0, $s0, -1           	# move to the next element
    	j shuffleLoop               	

doneShuffle:
	
	#jr $ra				# return to the caller, if you want to go on and print the array before each game jut comment this out.
	

    	# Print shuffled array(just get rid of the jr $ra if you want to print)
    	
    	li $t5, 0                   	# Index for printing
    	la $t4, cards          	# Reset pointer to start of `equations`

printShuffledLoop:
    	beq $t5, $t2, done          	# If index == 8, go to done

    	lw $a0, 0($t4)              	# Load current element
    	li $v0, 1                   	# Syscall: print integer
    	syscall

    	# Print space between numbers
    	li $v0, 4                   	# Syscall: print string
    	la $a0, space1              	# Load space character
    	syscall

    	# Move to next element
    	addi $t4, $t4, 4            	# Move to next array element
    	addi $t5, $t5, 1            	# Increment index
    	j printShuffledLoop         	# Repeat printing

done:
    	jr $ra   			# return to caller
    
