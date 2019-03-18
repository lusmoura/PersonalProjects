    .data
first:      .asciiz     "First string: "
last:       .asciiz     "Second string: "
full:       .asciiz     "Full string: "
newline:    .asciiz     "\n"
different:  .asciiz     "The strings are different"
equal:      .asciiz     "The strings are equal"

string1:    .space      256             # buffer for first string
string2:    .space      256             # buffer for second string
string3:    .space      512             # combined output buffer

    .text
    .globl main

main:
    la      $a0, first              # print first interaction
    la      $a1, string1
    jal     prompt
    move    $s0, $v0
    
    la      $a0, last               # print second interaction
    la      $a1, string2
    jal     prompt
    move    $s1, $v0
	
    bne     $s0, $s1, diff           # different sizes
    la      $t0, string1             # pointer to compare strings
    la      $t1, string2             # pointer to compare strings
    j strcmp    

prompt:
    # output the prompt
    li      $v0, 4                   # syscall to print string
    syscall

    # get string from user
    li      $v0, 8                   # syscall for string read
    move    $a0, $a1                 # place to store string
    li      $a1, 256                 # maximum length of string
    syscall

    li      $v1, 0x0A                # ASCII value for newline
    move    $a1, $a0                 # remember start of string

# strip newline and get string length
prompt_nltrim:
    lb      $v0, 0($a0)              # get next char in string
    addi    $a0, $a0, 1              # pre-increment by 1 to point to next char
    beq     $v0, $v1, prompt_nldone  # is it newline? if yes, fly
    bnez    $v0, prompt_nltrim       # is it EOS? no, loop

prompt_nldone:
    subi    $a0, $a0, 1              # compensate for pre-increment
    sb      $zero, 0($a0)            # zero out the newline
    sub     $v0, $a0, $a1            # get string length
    jr      $ra                      # return
    
strcmp:
    lb      $t2, 0($t0)              # gets char from frist string
    lb      $t3, 0($t1)              # gets char from second string
    bne     $t2, $t3, diff           # compare them
    beqz    $t2, eq                  # compare them to EOF
    addi    $t0, $t0, 1              # goes to the next char from string1
    addi    $t1, $t1, 1              # goes to the next char from string2
    j strcmp                         # loop

diff:
    li      $v0, 4                   # print strings are different
    la      $a0, different           
    syscall
    j end
    
eq:
    li      $v0, 4                  # print strings are equal
    la      $a0, equal
    syscall
    j end
    
end:                                # the end
    li $v0, 10
    syscall 