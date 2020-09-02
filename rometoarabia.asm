.data 
# This table looks up a Roman numeral and finds the corresponding Arabic Numeral
roman:		.asciiz "IVXLCDM"					# our valid Roman Numerals
arabic:		.byte 1, 5, 10, 50, 100, 500, 1000	# the Arabic Numerals that correspond to the Roman Numerals above
	
# Data declaration for the input string
in1:		.word 0								# declare storage for the input; initial value is 0
in2:		.asciiz "\n "						# declaration for string variable; .asciiz generates a null-terminated character string		
in3:		.asciiz "\n "						# declaration for string variable; .asciiz generates a null-terminated character string				
in4:		.asciiz "\n"						# declaration for string variable; .asciiz generates a null-terminated character string		
	
# Data declarations for conversion from Roman Numerals to Arabic Numerals
left:		.word 0								# will be used for the left pointer
sum:		.word 0								# summation used for the Roman Numeral to Arabic Numeral conversion algorithm
	
# Data declarations for the QtSpim display screen
sysPrompt:	.asciiz "\nEnter the Roman Numeral you want to convert in all uppercase (e.g. XLVII): "
userEntry:	.asciiz "\nRoman Numeral: "
outArabic:	.asciiz "Arabic Numeral: "
doItAgain:	.asciiz "\n\nDo you have more Roman Numerals to convert? Type 1 for YES or 2 for NO: "  
terminate:		.asciiz "\n\nProgram complete.\n"
reRun:		.word 2								# Declare storage for reRun variable; initial value is 2
      

#####-----Main Method-----#####
.text

.globl main

main:

		# Prompt the user to enter the Roman Numeral to convert
        li $v0, 4 				# load system call code for print_string
        la $a0, sysPrompt 		# load address of sysPrompt text into register $a0
        syscall
        
        # Read the Roman Numeral string that the user entered into the console      
        la $a0, in1 			# load address of input into register $a0; $a0 == memory address of string input buffer
        la $a1, in1 			# load address of input into register $a1; $a1 == length of string buffer (n)
        li $v0, 8 				# load system call code for read_string 
        syscall 
	
        sw $ra, 0($sp) 			# push the return address at register $ra to the last location on the stack 
        addi $sp, $sp, -4 		# update the stack pointer	     
        
		# Jump and link instruction to the subroutine at statement beginConvert that begins the conversion algorithm
		jal beginConvert 
       
		lw $ra, 0($sp) 			# pop the return address off the last location on the stack
		addi $sp, $sp, 4 		# update the stack pointer

# This subroutine outputs the results to the QtSpim display screen         
screenOutput:	  

		# Display the text 'Roman Numeral:'
        la $a0, userEntry 		# load address of userEntry into register $a0
        li $v0, 4 				# load system call code for print_string
        syscall
        
		# Display the roman numeral that the user entered
        la $a0, in1 			# load address of in1 into register $a0
        li $v0, 4 				# load system call code for print_string
        syscall
        
		# Display the text 'Arabic Numeral:'
        la $a0, outArabic 		# load address of outArabic into register $a0
        li $v0, 4 				# load system call code for print_string
        syscall
        
		# Display Arabic Numeral
        lw $a0, sum 			# Load summation into $a0
        li $v0,1 				# load system call code for print_int
        syscall
        
        # Prompt the user to see if they have another Roman Numeral to convert
        la $a0, doItAgain 		# load address of doItAgain into register $a0
        li $v0, 4 				# load system call code for print_string
        syscall 
        
        # Read user input to see if they have another Roman Numeral to convert (1 if 'yes'; 2 if 'no'; 'no' is the default)
        li $v0, 5 				# load system call code for read_int
        syscall
        
        # Store the user input
        sw $v0, reRun
        lw $t0, reRun
        
		# Jump to Exit if the user types a value that is not equal to 1
        bne $t0, 1, Exit   
            
		move $s0, $zero 		
		sw $zero, sum 			# reset summation to 0
		sw $zero, left 			# reset left pointer to 0
        
        j main					# return to beginning of main method if the user has entered 1
        
#####-----Roman Numeral to Arabic Numeral Conversion Method-----#####    

beginConvert: 
		sw $a1, 4($sp)			# push address to stack
		addi $sp, $sp, -4 		# update the stack pointer
	
		la $t2, in1				# load address of in1 into register $t2
		la $t3, roman 			# load address of roman into register $t3
		la $t4, arabic 			# load address of arabic into register $t3
	
# This routine loops through each character of the input string
loop:	
		lb $a0, ($t2) 			# moving from left-to-right, load the next byte
		beq $a0, 10, return 	# if char == 0, end of the input string has been reached; jump to 'return'
		beq $a0, 1, return 		# if char == 1, end of the line has been reached
	
		#li $v0, 11				# load system call code for print_character
		#syscall
		
		sw $ra, 8($sp) 			# push return address to the stack
		addi $sp, $sp, -4 		# update value of the stack pointer
	
		jal index				# While string[index] is not equal to null:
	
		lw $ra, 8($sp) 			# pop return address off the stack
		addi $sp, $sp, 4 		# update the stack pointer 

		addi $t2, $t2, 1 		# move to the next character in the input string 
	
		sw $ra, 8($sp) 			# push return address to the last location on the stack
		addi $sp, $sp, -4 		# update the stack pointer 
	
		jal loop 				# go through the loop again
	
		lw $ra, 8($sp) 			# pop the return address off the stack
		addi $sp, $sp, 4 		# update the stack pointer 
	
# Lookup the index of the character in the roman lookup table under .data
index:	
		lb $t5, ($t3) 			# load the byte of the roman table
		beq $a0, $t5, lookupVal # if char is equal to the corresponding element in the roman table, look it up in arabic table
	
		sw $ra, 12($sp) 		# push return address to the the stack
		addi $sp, $sp, -4 		# update the stack pointer
	
		jal loop2 				# jump to loop2 if no match is found in the table
	
		lw $ra, 12($sp) 		# Pop return address off the stack
		addi $sp, $sp, 4 		# update the stack pointer 
		
lookupVal:	
		la $t6, roman 			# load address of roman into register $t6
		la $t7, arabic			# load address of arabic into register $t7	
		sub $t8, $t3, $t6 		# Retrieve index value of the element that matches the character of interest
		add $t7, $t7, $t8 
		lbu $t9, ($t7) 			# $t9 is the Arabic Numeral that corresponds to the letter
		bgeu $t9, 232, convert	
		j afterLookup	

convert: 

		seq $a2, $t5, 68 		# If the character in question == D, set $a2 to 1; else, 0
		mul $t9, $t9, $zero
		beq $a2, 1, convertA
		addi $t9, $t9, 1000 	# Arabic Numeral of 1000 corresponds to the 'M' Roman Numeral 
	 	 
		j afterLookup
	

convertA: 
		addi $t9, $t9, 500
	
		j afterLookup
		
afterLookup: 
		sw $ra, 16($sp)
		addi $sp, $sp, -4 		# update the stack pointer
		
		jal initialize1
	
		addi $sp, $sp, 4 		# reset the stack pointer
		lw $ra, 16($sp) 		# pop return address off of the stack       
		jr $ra					# Return to register $ra	
	 	
# End of the loop
loop2:	
		addi $t3, $t3, 1 		# if no match is found, increment $t3
		jal index 				# jump to index

# Computation according to the rules of the Roman Numerals to Arabic Numerals conversion
initialize1: 
	# If string length is equal to 1, the sum is simply the Arabic Numeral equivalent of the single digit
		lw $s0, sum 			# load sum into register $s0
		beqz $s0, run1 			# if sum is equal to 0, we are in the first iteration of the loop. Update sum with Arabic Value and retrieve next character
		
		sw $ra, 20($sp) 		# push return address on to the stack
		addi $sp, $sp, -4		# update stack pointer
	
		jal computeSummation 	# jump to the subroutine that computes the sum
	
		addi $sp, $sp, 4 		# Reset the stack pointer
        lw $ra, 20($sp) 		# pop return address off stack
        jr $ra					# Return to the return address
	
# Add value of the first digit to the running sum	
run1:	
		add $s0, $s0, $t9 		
		sw $s0, sum 			# store elements in $s0 to the summation
		sw $t9, left 			# $t9 is the current character. Becomes the left element 'left' for next run	
		la $t3, roman 			# load address of roman into register $t3
		addi $t2, $t2, 1 		# Add 1 to $t2, so that we can select next character in the input string	
		jal loop 				# Return to loop to retrieve the next character

# Roman Numeral to Arabic Numeral Rules		
# A lower value to the left of a symbol is subtracted 'e.g. IV == 5-1'
# A lower or equal value to the right of a symbol is added 'e.g. VI == 5+1'
computeSummation: 
		addi $sp, $sp, 8 		# Reset the stack pointer
		lw $t1, left 			# pop numeral to the left of the current numeral	
		sw $t9, left 			# Reset left pointer so it points to the current character 
 	
		la $t3, roman 			# Load address of roman array into $t3 (reset pointer)
		
		# Follow Roman Numeral to Arabic Numeral Rules
		bge $t1, $t9, addition 	
		blt $t1, $t9, subtraction 

addition:	
		lw $s0, sum 			# Load sum into $s0
		add $s0, $s0, $t9 		# Add value of current characters Arabic Numeral value to the sum
		sw $s0, sum 			# Store the result in sum
	
		la $t3, roman 			# load address of roman into register $t3
		addi $t2, $t2, 1 		# 1 is added to $t2 in order to get the next character in the input string
	
		jal loop 				# Return to the beginning of the loop 

subtraction: 
		lw $s0, sum 			# Load sum into $s0
		mul $t1, $t1, 2 		# Multiply $1 by 2; Subtraction two times in order to get desired result
		sub $t9, $t9, $t1 		# Subtraction of previous character - (2* current character))
		add $s0, $s0, $t9 		# Update the running sum
		sw $s0, sum 			# Store result in sum	
	
		la $t3, roman 			# load address of roman into register $t3
		addi $t2, $t2, 1 		# Addition done in order to move to next character
	
		jal loop 				# Return to the beginning of the loop 
	
# Return to the main method	
return:	
		sw $s0, sum 			# store elements in $s0 to the summation
        j screenOutput 			# Go to screen output
      
#####-----Exiting the Program-----#####       

Exit: 
		li $v0, 4				# load system call code for print_string
		la $a0, terminate		# Load address for terminate (a string)
		syscall

		li $v0, 10 				# system call code for exit is 10
		syscall					# call operating system to perform exit operation