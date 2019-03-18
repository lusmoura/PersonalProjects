    .data
    .align 0
first:      .asciiz "First string: "
final:      .asciiz "New string is: "
newline:    .asciiz "\n"
 
buffer1:    .space   256
buffer2:    .space   256

    .text
    .globl main

main:
    la       $a0, first                   # get string
    la       $a1, buffer1
    jal      prompt
    move     $s0, $v0                     # get string size
 
    la       $t0, buffer1                 # get address for both buffers
    la       $t1, buffer2
    j strcpy
    
prompt:
    # output the prompt
    li      $v0, 4                        # syscall to print string
    syscall

    # get string from user
    li      $v0, 8                        # syscall for string read
    move    $a0, $a1                      # place to store string
    li      $a1, 256                      # maximum length of string
    syscall
 
    li      $v1, 0x0A                     # ASCII value for newline
    move    $a1, $a0                      # remember start of string

# strip newline and get string length
prompt_nltrim:
    lb      $v0, 0($a0)                   # get next char in string
    addi    $a0, $a0, 1                   # pre-increment by 1 to point to next char
    beq     $v0, $v1, prompt_nldone       # is it newline? if yes, fly
    bnez    $v0, prompt_nltrim            # is it EOS? no, loop

prompt_nldone:  
    subi    $a0, $a0, 1                   # compensate for pre-increment
    sb      $zero, 0($a0)                 # zero out the newline
    sub     $v0, $a0, $a1                 # get string length
    jr      $ra                           # return
    
strcpy:
    lb       $t2, 0($t0)                  # load char from original string
    sb       $t2, 0($t1)                  # store it in the second string
    beqz     $t2, end                     # if char is zero, end of the word
    addi     $t0, $t0, 1                  # go to the next char
    addi     $t1, $t1, 1                  # go to the next position
    j strcpy
    
end:
    li       $v0, 4                       # print "new string is: " 
    la       $a0, final
    syscall 

    li       $v0, 4                       # instruction to print string
    la       $a0, buffer2                 # string to print
    syscall
    
    li       $v0, 10                      # the end
    syscall    