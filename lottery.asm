           .globl main
main:                               # odds of winning lottery given 4 inputs
            .text

            # set arguments

            add $v0, $zero, 4       # print string
            la $a0, str1            # set string
            syscall                 # print string

            add $v0, $zero, 5       # prompt for int
            syscall                 # get int input
            move $s0, $v0           # save input in $s0

            add $v0, $zero, 4       # print string
            la $a0, str2            # set string
            syscall                 # print string

            add $v0, $zero, 5       # prompt for int
            syscall                 # get int input
            move $s1, $v0          # save input in $s1

            add $v0, $zero, 4       # print string
            la $a0, str3            # set string
            syscall                 # print string

            add $v0, $zero, 5       # prompt for int
            syscall                 # get int input
            move $s2, $v0           # save input in $s2

            add $v0, $zero, 4       # print string
            la $a0, str4            # set string
            syscall                 # print string

            add $v0, $zero, 5       # prompt for int
            syscall                 # get int input
            move $s3, $v0           # save input in $s3

            # for testing
            # addi $s0, $zero, 15     # N1 large pool of possible numbers
            # addi $s1, $zero, 8      # r1 selection from large pool
            # addi $s2, $zero, 2      # N2 small pool of possible numbers
            # addi $s3, $zero, 1      # r2 selction from small pool

            # calculate factorials

            move $a0, $s0           # move N1 to subroutine argument
            move $a1, $s1           # move r1 to subroutine argument
            jal simplefact          # call modified factorial subroutine
            move $s4, $v0           # store calculated numerator

            move $a0, $s1           # move r1 to subroutine argument
            jal factrl              # call factorial subroutine
            move $s5, $v0           # store calculated factorial/denominator

            move $a0, $s2           # move N1 to subroutine argument
            move $a1, $s3           # move r1 to subroutine argument
            jal simplefact          # call modified factorial subroutine
            move $s6, $v0           # store calculated numerator

            move $a0, $s3           # move r1 to subroutine argument
            jal factrl              # call factorial subroutine
            move $s7, $v0           # store calculated factorial/denominator

            # $s4 contains numerator of large pool
            # $s5 contains denominator of large pool
            # $s6 contains numerator of small pool
            # $s7 contains denominator of small pool

            # calculate individual combinations

            div $s4, $s5
            mflo $s4

            div $s6, $s7
            mflo $s6

            # calculate overall odds

            mul $s4, $s4, $s6

            # print result to console

            addi $v0, $zero, 4      # print string
            la $a0, str             # the text for odds
            syscall                 # call operating system

            addi $v0, $zero, 1      # print integer
            add $a0, $zero, $s4     # the calculated odds
            syscall                 # call operating system

            addi $v0, $zero, 4      # print string
            la $a0, stopped         # the text for output
            syscall                 # call opsys

            addi $v0, $zero, 10     # finished .. stop .. return
            syscall                 # to the Operating System


######### Factorial Subroutine Fall 2016
#
# Given n, in register $a0;
# calculate n!, store and return the result in register $v0

factrl:     sw $ra, 4($sp)          # save the return address
            sw $a0, 0($sp)          # save the current value of n
            addi $sp, $sp, -8       # move stack pointer
            slti $t0, $a0, 2        # save 1 iteration, n=0 or n=1; n!=1
            beq $t0, $zero, L1      # not less than 2, calculate n(n-1)!
            addi $v0, $zero, 1      # n=1; n!=1
            jr $ra                  # now multiply

L1:         addi $a0, $a0, -1       # n = n-1

            jal factrl              # now (n-1)!

            addi $sp, $sp, 8        # reset the stack pointer
            lw $a0, 0($sp)          # fetch saved (n-1)
            lw $ra, 4($sp)          # fetch return address
            mul $v0, $a0, $v0       # multiply (n)*(n-1)
            jr $ra                  # return value n!

# P Snyder 14 August 2016
######### End of the subroutine


######### Modified Factorial Loop Subroutine Spring 2019
#
# Given n, in register $a0;
# Given r, in register $a1;
# calculate n*(n-1)*(n-2)*...*(n-(r-1))
# store and return the result in register $v0

simplefact: sw $ra, 8($sp)          # save the return address
            sw $a0, 4($sp)          # save the current value of n
            sw $a1, 0($sp)          # save the current value of r

            addi $t0, $zero, 1      # set counter
            lw $t1, 4($sp)          # set n
            lw $t2, 0($sp)          # set r
            move $v0, $t1           # set first value in numerator
            addi $t7, $zero, 1     # check if r = 1
            beq $t2, $t7, loopend   # don't enter loop if r = 1


loop:       addi $t0, $t0, 1        # increment counter
            addi $t1, $t1, -1       # decrement n
            mul $v0, $t1, $v0       # find n*(n-1)
            blt $t0, $t2, loop      # counter < r loop again

loopend:    lw $ra, 8($sp)          # fetch return address
            jr $ra                  # return value n!

# S Braddock 03 13 2018
# Modified from Factorial Subroutine
######### End of the subroutine

            .data
str:    .asciiz "The odds of winning the jackpot are 1 in "
str1:   .asciiz "Please enter the total number in the large pool:\n"
str2:   .asciiz "Please enter the total number picked from the large pool:\n"
str3:   .asciiz "Please enter the total number in the small pool:\n"
str4:   .asciiz "Please enter the total number picked from the small pool:\n"
stopped:
        .asciiz "\nStopped."