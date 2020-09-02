.globl main
    main: # sum of the integers from 1 to 100
    
        .text
        add $t0, $zero, $zero # I is zero
        add $s0, $zero, $zero # sum is zero
        addi $t1, $zero, 100 # set the limit value (100)
        
    loop:
        addi $t0, $t0, 1 # I = I + 1
        mult $t0, $t0  # get I^2
        mflo $t2  # store the product - square in $t2
        
        add $s0, $s0, $t2 # sum = sum + (I^2)
        blt $t0, $t1, loop # I < 100 loop to do again
        
        addi $v0, $zero, 4 # print string
        la $a0, str # the text for output
        syscall # call opsys
        
        addi $v0, $zero, 1 # print integer
        add $a0,$zero, $s0 # the integer is sum
        syscall # call opsys
        
        addi $v0, $zero, 10 # finished .. return
        syscall # to the Operating System
        
        .data
        
    str:
        .asciiz "The sum of squares from 1 ... 100 is "
        
    stopped:
	.asciiz "\nStopped."