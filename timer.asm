
.data
timerMessage:    .asciiz "Time elapsed: "
newline:         .asciiz "\n"
colon:           .asciiz ":"
winTime1:         .asciiz "You won in "
winTime2:		.asciiz "!"
formatSecond:    .asciiz "0"


    .text
    .globl startTime
    .globl incrementTime
    .globl displayTime
    .globl winningTime
    
   
# Start Timer
startTime:
    # Initialize counters
    li $s6, 0             		# Initialize minute counter to 0
    li $s7, 0          		# Initialize seconds counter to 0
    
    jr $ra

incrementTime:
     li $t1, 60            		# Set second counter to 60 (1 minute)
      
    addi $s7,$s7,1 			#inc sec 1
    beq $t1,$s7,addMinute
   
    jr $ra
winningTime:
    li $v0, 4
    la $a0,winTime1
    syscall
    
    li $v0, 1
    move $a0, $s6            		# Move seconds to $a0
    syscall
    
    li $v0, 4
    la $a0,colon
    syscall
    
    blt $s7, 10, format       		# If seconds are less than 10, format with leading zero
    
    li $v0, 1
    move $a0, $s7            		# Move seconds to $a0
    syscall
    
     li $v0, 4
    la $a0,winTime2
    syscall
    
    li $v0, 4
    la $a0,newline
    syscall

    jr $ra
    
displayTime:
    
    li $v0, 4
    la $a0,timerMessage
    syscall
    
    li $v0, 1
    move $a0, $s6            		# Move seconds to $a0
    syscall
    
    li $v0, 4
    la $a0,colon
    syscall
    
    blt $s7, 10, format       		# If seconds are less than 10, format with leading zero
    
    li $v0, 1
    move $a0, $s7            		# Move seconds to $a0
    syscall
    
    li $v0, 4
    la $a0,newline
    syscall

    jr $ra
    	
format:
	li $v0, 4
	la $a0, formatSecond
	syscall 
	
	li $v0, 1
    	move $a0, $s7           	# Move seconds to $a0
    	syscall
    
    	li $v0, 4
    	la $a0,newline
    	syscall
	jr $ra	
	
addMinute:
     add $s6,$s6,1
     li $s7,0 				#resest
     jr $ra
 
stopTimer:
     li $v0, 4
     la $a0, winningTime
     syscall 
     
     j end
end:
     li $v0, 10
     syscall

	

