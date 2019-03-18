    .data
first:      .asciiz     "First string: "
last:       .asciiz     "Second string: "
full:       .asciiz     "Full string: "
newline:    .asciiz     "\n"

string1:    .space      256             # buffer for first string
string2:    .space      256             # buffer for second string
string3:    .space      512             # combined output buffer

    .text

main:
    # prompt and read first string
    la      $a0, first               # prompt string
    la      $a1, string1             # buffer address
    jal     prompt
    move    $s0, $v0                 # save string length

    # prompt and read second string
    la      $a0, last                # prompt string
    la      $a1, string2             # buffer address
    jal     prompt
    move    $s1, $v0                 # save string length

    # point to combined string buffer
    # NOTE: this gets updated across strcat calls (which is what we _want_)
    la      $a0, string3

    # decide which string is shorter based on lengths
    blt     $s0, $s1, string1_short

    # string 1 is longer -- append to output
    la      $a1, string1
    jal     strcat

    # string 2 is shorter -- append to output
    la      $a1,string2
    jal     strcat

    j       print_full

string1_short:
    # string 2 is longer -- append to output
    la      $a1, string2
    jal     strcat

    # string 1 is shorter -- append to output
    la      $a1, string1
    jal     strcat

# show results
print_full:
    # output the prefix message for the full string
    li      $v0, 4
    la      $a0, full
    syscall

    # output the combined string
    li      $v0, 4
    la      $a0, string3
    syscall

    # finish the line
    li      $v0, 4
    la      $a0, newline
    syscall

    li      $v0,10
    syscall

# prompt -- prompt user for string
#
# RETURNS:
#   v0 -- length of string (with newline stripped)
#
# arguments:
#   a0 -- address of prompt string
#   a1 -- address of string buffer
#
# clobbers:
#   v1 -- holds ASCII for newline
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
    addi    $a0,$a0, 1               # pre-increment by 1 to point to next char
    beq     $v0,$v1, prompt_nldone   # is it newline? if yes, fly
    bnez    $v0, prompt_nltrim       # is it EOS? no, loop

prompt_nldone:
    subi    $a0, $a0, 1              # compensate for pre-increment
    sb      $zero, 0($a0)            # zero out the newline
    sub     $v0, $a0, $a1            # get string length
    jr      $ra                      # return

# strcat -- append string
#
# RETURNS:
#   a0 -- updated to end of destination
#
# arguments:
#   a0 -- pointer to destination buffer
#   a1 -- pointer to source buffer
#
# clobbers:
#   v0 -- current char
strcat:
    lb      $v0, 0($a1)              # get the current char
    beqz    $v0, strcat_done         # is char 0? if yes, done

    sb      $v0, 0($a0)              # store the current char

    addi    $a0, $a0, 1              # advance destination pointer
    addi    $a1, $a1, 1              # advance source pointer
    j       strcat

strcat_done:
    sb      $zero, 0($a0)            # add EOS
    jr      $ra                      # return