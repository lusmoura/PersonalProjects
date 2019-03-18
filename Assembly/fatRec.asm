    .data
    .align 0
digite:    .asciiz "Digite o numero: "
ans:       .asciiz "O fatorial de "
eh:        .asciiz " eh "
newline:   .asciiz "\n"
    
    .text
    .globl main

main:
    li       $v0, 4                   # print interaction
    la       $a0, digite
    syscall
    
    li       $v0, 5                   # get number
    syscall
 
    move     $s0, $v0                 # save the number in s0
    move     $a0, $v0                 # save the same number in a0, to use as a paramether
        
    jal      fat                      # call the function
    move     $s1, $v0                 # save the return value
    j        end
    
fat:
    addi     $sp, $sp, -8             # get space in the stack
    sw       $a0, 0($sp)              # store curr value
    sw       $ra, 4($sp)              # store return address
    
    slti     $t0, $a0, 1              # set on if less than 1
    beq      $t0, $zero, contFat      # if it's different than one, go to continueFat
    
    addi     $v0, $zero, 1            # return 1
    addi     $sp, $sp, 8              # reduces size of stack
    jr       $ra

contFat:
    addi     $a0, $a0, -1             # decreases n
    jal      fat                      # go back to the function
    
    lw       $a0, 0($sp)              # after all the recursion is made, load value back from the stack
    lw       $ra, 4($sp)              # get return address
    addi     $sp, $sp, 8              # reduces size of stack
    mul      $v0, $a0, $v0            # n * fat(n - 1) 
    jr       $ra                      # return with result
    
end:
    li       $v0, 4                   # print string
    la       $a0, ans
    syscall
    
    li       $v0, 1                   # print original number
    move     $a0, $s0
    syscall
    
    li       $v0, 4                   # print strings
    la       $a0, eh
    syscall
    
    li       $v0, 1                   # print ans
    move     $a0, $s1
    syscall
    
    li       $v0, 4                   # print \n
    la       $a0, newline
    syscall