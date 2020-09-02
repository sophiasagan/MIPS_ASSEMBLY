######### Factorial Subroutine Fall 2016
#
# Given n, in register $a0;
# calculate n!, store and return the result in register $v0
factrl: sw $ra, 4($sp) # save the return address
 sw $a0, 0($sp) # save the current value of n
addi $sp, $sp, -8 # move stack pointer
slti $t0, $a0, 2 # save 1 iteration, n=0 or n=1; n!=1
beq $t0, $zero, L1 # not less than 2, calculate n(n-1)!
addi $v0, $zero, 1 # n=1; n!=1
jr $ra # now multiply
L1: addi $a0, $a0, -1 # n = n-1
jal factrl # now (n-1)!
addi $sp, $sp, 8 # reset the stack pointer
lw $a0, 0($sp) # fetch saved (n-1)
lw $ra, 4($sp) # fetch return address
mul $v0, $a0, $v0 # multiply (n)*(n-1)
jr $ra # return value n!
# P Snyder 14 August 2016
######### End of the subroutine
