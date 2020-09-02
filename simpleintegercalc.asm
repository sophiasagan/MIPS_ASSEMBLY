	.data		

doItAgain:		.asciiz "\n\nDo you have more expressions to calculate? Type 1 for YES or 2 for NO: "  
terminate:		.asciiz "\n\nProgram complete.\n"
reRun:			.word 2	# Declare storage for reRun variable; initial value is 2
	
Heading:		.ascii	"\nSimple Integer Calculator \n\n"
				.ascii	"Computer Organization, EN.605.204.81.SP19  \n"
				.asciiz	"Author: Sophia Braddock \n\n"	
Prompt:
	.asciiz	"\nPlease enter the expression (e.g. SUM  = 63 * 72): "
	
Input:
	.space 20			# Accepts as input a string of up to 20 characters; Note that a word is 4 bytes in MIPS

VarName:
	.asciiz	"       "   # Allocate space for the alphabetic variable name	
	
Operator:
	.asciiz	"   " 		# Operator will be stored in the middle, with empty space on left and right
	
Equals:
	.asciiz 	" = "	# Allocates space for storage of the '=' character



	.text
main:	
	# display the header
	la $a0, Heading				# load address of the program header to display to the console
	li $v0, 4					# load system call code for print_string
	syscall

promptUser:
	# prompt the user
	la $a0, Prompt				# load address of the prompt to be displayed on the screen
	li $v0, 4					# load system call code for print_string
	syscall	
	
	# read the input string from console and store it at address Input:
	la $a0, Input				# load the destination address for the input string 
	li $a1, 20					# load the maximum length of the input string; in this case 20 bytes; 1 byte per character
	li $v0, 8					# load system call code for read string
	syscall

	# set up the input string pointer
	la  $a1, Input				# set $a1 to the address of where the input string is currently stored

	# Clear register $t1 in order to prepare to store the variable name
	li   $t5,' '			   	# load the ' ' character
	la   $t1, VarName			# retrieve address where character should be stored
	sb   $t5, 0($t1)			# store character to zero out $t1
	sb   $t5, 1($t1)			# store character to zero out $t1
	sb   $t5, 2($t1)			# store character to zero out $t1
	sb   $t5, 3($t1)			# store character to zero out $t1
	sb   $t5, 4($t1)			# store character to zero out $t1
	sb   $t5, 5($t1)			# store character to zero out $t1	
	
	#-----------------------------------------------------------------------------------------------------
	# read the 1st character in the alphabetic variable name and store it into memory
	move $t0, $zero	    		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)			# load character into $t0
	la   $t1, VarName			# retrieve address where character should be stored
	sb   $t0, 0($t1)			# store character for later printing
	
	# Test to see if we have any more characters to add in the alphabetic variable name
	addi $a1, $a1, 1			# increment input character pointer
	move $t0, $zero	    		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)			# load character into $t0
	li   $t5,' '			   	# load the ' ' character
	beq  $t0,$t5,getStarted  	# if whitespace, move forward and start reading the first operand
	
	#-----------------------------------------------------------------------------------------------------
	# read the 2nd character in the alphabetic variable name and store it into memory
	sb   $t0, 1($t1)			# store character for later printing
	
	# Test to see if we have any more characters to add in the alphabetic variable name
	addi $a1, $a1, 1			# increment input character pointer
	move $t0, $zero	    		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)			# load character into $t0
	li   $t5,' '			   	# load the ' ' character
	beq  $t0,$t5,getStarted  	# if whitespace, move forward and start reading the first operand	
	#-----------------------------------------------------------------------------------------------------
		# read the 3rd character in the alphabetic variable name and store it into memory
	sb   $t0, 2($t1)			# store character for later printing
	
	# Test to see if we have any more characters to add in the alphabetic variable name
	addi $a1, $a1, 1			# increment input character pointer
	move $t0, $zero	    		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)			# load character into $t0
	li   $t5,' '			   	# load the ' ' character
	beq  $t0,$t5,getStarted  	# if whitespace, move forward and start reading the first operand	
	#-----------------------------------------------------------------------------------------------------
		# read the 4th character in the alphabetic variable name and store it into memory
	sb   $t0, 3($t1)			# store character for later printing
	
	# Test to see if we have any more characters to add in the alphabetic variable name
	addi $a1, $a1, 1			# increment input character pointer
	move $t0, $zero	    		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)			# load character into $t0
	li   $t5,' '			   	# load the ' ' character
	beq  $t0,$t5,getStarted  	# if whitespace, move forward and start reading the first operand	
	#-----------------------------------------------------------------------------------------------------
		# read the 5th character in the alphabetic variable name and store it into memory
	sb   $t0, 4($t1)			# store character for later printing
	
	# Test to see if we have any more characters to add in the alphabetic variable name
	addi $a1, $a1, 1			# increment input character pointer
	move $t0, $zero	    		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)			# load character into $t0
	li   $t5,' '			   	# load the ' ' character
	beq  $t0,$t5,getStarted  	# if whitespace, move forward and start reading the first operand	
	#-----------------------------------------------------------------------------------------------------
		# read the 6th character in the alphabetic variable name and store it into memory
	sb   $t0, 5($t1)			# store character for later printing
	
	# Test to see if we have any more characters to add in the alphabetic variable name
	addi $a1, $a1, 1			# increment input character pointer
	move $t0, $zero	    		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)			# load character into $t0
	li   $t5,' '			   	# load the ' ' character
	beq  $t0,$t5,getStarted  	# if whitespace, move forward and start reading the first operand	
	#-----------------------------------------------------------------------------------------------------

getStarted:		
	# read the first operand
	addi $a1, $a1, 3	# increment input character pointer to skip past the operator, space
	jal  readOperand	# read the first operand, advancing string pointer $a1
	move $s1, $v0		# store return value, which is operand 1, into $s1

	# read operator and store it into the memory
	addi $a1, $a1, 1	# increment input character pointer to skip space
	move $t0, $zero		# clear out $t0 in preparation for storing a character in it
	lbu  $t0, 0($a1)	# load operator character into $t0
	la   $t1, Operator	# retrieve address where character should be stored
	sb   $t0, 1($t1)	# store operator character for later printing

	# advance past the space on input line
	addi $a1, $a1, 2	# increment input character pointer in order to skip space

	# read second operand
	jal  readOperand	# read the second operand, advancing string pointer $a1
	move $s2, $v0		# store return value, which is operand 2, into register $s2

	# execute the operation with the operands.  
	# First load the arguments.
	move $a1, $s1		# put the 1st operand into $a1
	move $a2, $s2		# put the 2nd operand into $a2
	
	# retrieve operator character, to put into $a3
	move $a3, $zero		# clear $a3 to receive a byte
	la   $t0, Operator	# address where operator string is
	lbu  $a3, 1($t0)	# load the operator character
	
	# execute the operation
	jal  executeOperation	
	move $s3, $v0		# store result from operation into $s3

	# print the result, printing VarName, '=', answer
	#   shown as:  VarName = s3
	la   $a0, VarName	# syscall to print string
	li   $v0, 4
	syscall	
	
	# Print the equals sign
	la   $a0, Equals	# load system call code for print_string
	li   $v0, 4
	syscall
	
	# Print the result
	li   $v0, 1			# syscall to print integer
	move $a0, $s3		# put value to print into $a0
	syscall

	# Prompt the user to see if they have another expression to calculate
    la $a0, doItAgain 	# load address of doItAgain into register $a0
    li $v0, 4 			# load system call code for print_string
    syscall 
        
    # Read user input to see if they have another Roman Numeral to convert (1 if 'yes'; 2 if 'no'; 'no' is the default)
    li $v0, 5 			# load system call code for read_int
    syscall
        
    # Store the user input
    sw $v0, reRun
    lw $t0, reRun
        
	# Jump to Exit if the user types a value that is not equal to 1
    bne $t0, 1, Exit   
            
	b promptUser 		#return to the display prompt if the user wants to continue

#####-----readOperand Method-----#####
readOperand:
	# push the return address to the stack
	addiu $sp, $sp, -24		# decrement the stack pointer		
	sw    $ra, 0($sp)		# store the return address on the stack

	# retrieve the first input character, stored in $t0
	move $t0, $zero			# clear $t0 in order to prepare it to store a character
	lbu  $t0, 0($a1)		# load the first character in the input string into $t0

	jal  readDecimal		# Jump and link to the readDecimal method
	b    endOfOperand		# branch to the endOfOperand method
	
endOfOperand:
	# pop the stack
	lw   $ra, 0($sp)		# restore the return address from stack
	addiu $sp, $sp, 24		# restore the stack pointer
	jr   $ra				# return to the caller

#####-----readDecimal Method-----#####

readDecimal:
	move $v0, $zero	# $v0 = 0 ; clear the register used to accumulate the answer
	
nextDecimal:
    # loop while the input is not a space or return character.
	addi $t0, $t0, -48		# $t0=$t0-'0';  adjustment
	
	# v0 = v0 * 10 + t0;  Accumulation of the decimal answer
	move $t1, $zero			# clear register $t1 in order to prepare for loading 10
	addi $t1, $t1, 10		# $t1 = 10; Load 10 into register $t1
	mult $v0, $t1			# $v0 = $v0 * 10;
	mflo $v0				# restore the result of multiplication back into $v0
	add  $v0, $v0, $t0		# $v0 = $v0 + $t0; add the character 

	addi $a1, $a1, 1		# move the input string pointer forward by 1
	lbu  $t0, 0($a1)		# store the next input character into $t0

	# check for the loop termination condition: while ( (t0 != ' ') && (t0 != '\n'))
	li   $t1,' '			# load the ' ' character
	beq  $t0,$t1,decimalEnd
	li  $t1,'\n'			# load the '\n' character
	bne $t0,$t1,nextDecimal	# (t0 != '\n) so this passed the test of 
							# ((t0 != ' ') && (t0 != '\n')), so go loop for the next digit
decimalEnd:
	jr $ra					# return to caller

#####-----executeOperation Method-----#####

executeOperation:
	# Clear the destination register
	move $v0, $zero
	
	# store the operator argument register $a3 into local use register $t0
	move $t0, $a3			# $t0 = $a3

	# Check the operator character to see what operation to execute
	# Check if ( operator == '+') 
	li   $t1,'+'			# load an '+'
	bne  $t0,$t1,checkSub	# (operator != '+'),  Try the next condition.
	add  $v0, $a1, $a2		# (operator == '+'), so $v0 = $a1+$a2;
	b    operationComplete	# branch to operationComplete
	
checkSub:
	# Check if ( operator == '-') 
	li   $t1,'-'			# load an '-'
	bne  $t0,$t1,checkMult	# (operator != '-'),  Try the next condition.
	sub  $v0, $a1, $a2		# (operator == '-'), so $v0 = $a1-$a2;
	b    operationComplete	# branch to operationComplete
	
checkMult:
	# Check if ( operator == '*') 
	li   $t1,'*'			# load an '*'
	bne  $t0,$t1,checkDiv	# (operator != '*'),  Try the next condition.
	mult $a1, $a2			# (operator == '*'), so $v0 = $a1*$a2;
	mflo $v0
	b    operationComplete	# branch to operationComplete
	
checkDiv:
	# Check if ( operator == '/') 
	li   $t1,'/'			# load an '/'
	div  $a1, $a2			# (operator == '/'), so $v0 = $a1*$a2;
	mflo $v0
	b    operationComplete	# branch to operationComplete

operationComplete:
	jr   $ra				# return to caller

#####-----Exiting the Program-----#####       

Exit: 
		li $v0, 4				# load system call code for print_string
		la $a0, terminate		# Load address for terminate (a string)
		syscall

		li $v0, 10 				# system call code for exit is 10
		syscall					# call operating system to perform exit operation