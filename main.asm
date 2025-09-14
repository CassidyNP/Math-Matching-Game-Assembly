.include "board.asm"
.include "gameLogic.asm"
.include "shuffleLogic.asm"
.include "timer.asm"
.include "SysCalls.asm"
.include "sound.asm"
.data
	cards:	.word 4, 7, 9, 12, 5, 6, 8, 10 ,20, 35, 45, 60, 25, 30, 40, 50 	# these are the answers and the first number of the equations
	answers:	.word ,20, 35, 45, 60, 25, 30, 40, 50 			#answers for the equations
	matched:	.space 64
	
	titleMsg:		.asciiz			"---------MATCH MATCHING GAME--------\n"
	cardContainsMsg:	.asciiz 		"Card contains: "
	unmatchedMsg:		.asciiz 		"\nUnmatched Cards Remaining: "
	timesFiveEqualsMsg: 	.asciiz 		" * 5 \n"
	newLine1:		.asciiz			"\n"
	tryAgainMsg:		.asciiz			"\nNot a Match ! Try Again\n"
	prompt:			.asciiz			"Please choose a card: "
	matchMsg:		.asciiz			"\n---------MATCH!---------\n"
	winMsg:			.asciiz 		"CONGRATS ! YOU HAVE MATCHED ALL THE CARDS !\n Would you like to play again? \n RESPOND 0 FOR NO AND 1 FOR YES \n"
	thankMsg:		.asciiz			"\n---------THANK YOU FOR PLAYING !---------\n"
	
	
	
.text
.globl main
.globl gameLoop
.globl incorrectPenalty

main:
    
	#Prints the title
	li $v0, SysPrintString
	la $a0, titleMsg
	syscall 
	
gameStart:
	#Start the game
	jal initializeBoard
	
	
	#shuffle the cards
	jal shuffleCards
	
	#initialize the unmatched counter
	li $s5, 16
	
	#initialize timer
	jal startTime
	
gameLoop:
	li $t8, 0					# this is the counter to see if there is double equations picked
	li $t6, 0					# this is the counter to see if there is double answers picked
	

	# this is just a new line print
	li $v0, 4					#SysPrintString
	la $a0, unmatchedMsg
	syscall
	
	# print the umatched count
	li $v0, 1					#SysPrintInt	
	move $a0, $s5
	syscall 
	
	# this is just a new line print
	li $v0, 4					#SysPrintString
	la $a0, newLine1
	syscall

    	# Display the board with the current matched status
    	jal displayBoard
	
    	# Prompt the user for the first card
    	li $v0, SysPrintString
    	la $a0, prompt
    	syscall 

    	# Read the first card choice
    	li $v0, SysReadInt
    	syscall 
    	move $t0, $v0       				# Store the first card index in $t0
    
    
    	jal incrementTime #we are stimulating 'a second' after each user input 
    	
    	# Reveal the first card
    	jal revealCard

    	# Prompt the user for the second card
    	li $v0, SysPrintString
    	la $a0, prompt
    	syscall 

    	# Read the second card choice
    	li $v0, SysReadInt
    	syscall 
    	move $t0, $v0       				# Store the second card index in $t0

	jal incrementTime #we are stimulating 'a second' after each user input 
	
    	# reveal the second card
    	jal revealCard

	jal displayTime
	# check if two of the same type of card were picked
    	beq $t8, 2, tryAgain
    	beq $t6, 2, tryAgain
    	
    	# Check if the two selected cards match
    	jal checkMatch
    	bnez $v0, correctSound   			# If match is found, jump to match handling
    
    	# If no match, display "Try Again" message
    	li $v0, 4
    	la $a0, tryAgainMsg
    	syscall
    	
    	
    	jal incorrectSound
    	
incorrectPenalty:

	#adding 3 seconds as a penalty for getting it wrong
	# the reason did not use :  add $s7,$s7,3  did not properly check the time
	jal incrementTime
	jal incrementTime
	jal incrementTime
	j gameLoop	
	
  
tryAgain:
	# If no match, display "Try Again" message
	li $s1, 0					# re do the equations index
	li $s2, 0					# re do the answers index
	
    	li $v0, 4
    	la $a0, tryAgainMsg
    	syscall
    	
    	jal incorrectSound
    

matchFound:

    	# Display match message
    	li $v0, SysPrintString
    	la $a0, matchMsg
    	syscall
    	
    	
    	subi $s5, $s5, 2				# increment the matched counter

    	# Check if all pairs are matched (checkWin function)
    	jal checkWin
    	beqz $v0, gameLoop    				# If not all cards are matched, continue game loop
	j winSound
	j gameWin
	
gameWin:
	#Display Time passed
	jal winningTime
	
    	# Display win message and ask if the player wants to play again
   	li $v0, SysPrintString
   	la $a0, winMsg
    	syscall

    	# Read player response
    	li $v0, SysReadInt
    	syscall 
    	beqz $v0, exit       				# If response is 0 (No), exit the game
    	j gameStart           				# If response is 1 (Yes), start a new game

exit:
	# print thank you message
	li $v0, SysPrintString
   	la $a0, thankMsg
    	syscall
	
    	# Exit the program
    	li $v0, SysExit
    	syscall
