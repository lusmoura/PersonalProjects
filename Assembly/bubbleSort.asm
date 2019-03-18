.data
.align 2
	array: .word 7 5 2 1 1 3 4
	espaco: .asciiz " "

.text
.globl main

main:
	addi $s0, $zero, 7      # s0 = MAX
	addi $a1, $zero, 4      # a1 = 4
	addi $t0, $zero, 0       # t0 = i = Max-1
	mul $s1, $s0, $a1       # s1 = 4*MAX


loopi:
	beq $t0, $s1, endloopi  # parada do loopi (i == 4*MAX)

	addi $t1, $s0, -1       # j = MAX - 1
	mul $t1, $t1, $a1       # j *= 4


loopj:
	beq $t1, $t0, endloopj  # parada do loopj (j == i)
	
	lw $t3, array($t1)      # t3 = vet[t1]
	sub $t5, $t1, $a1       # t5 = t1 - 4
	lw $t4, array($t5)      # t4 = vet[t5] = vet[t1-1]

	blt $t3, $t4, swap      # se vet[j] < vet[j-1] faz swap


continueLoopj:
	sub $t1, $t1, $a1       # j += 4
	j loopj


swap:
	sw $t4, array($t1)      # vet[t1] = t4 -> vet[j] = j-1
	sw $t3, array($t5)      # vet[t5] = t3 -> vet[j-1] = j
	j continueLoopj         # após swap, volta para o loop


endloopi:
	addi $t0, $zero, 0     # i = 0
	j printVet
		

endloopj:
	add $t0, $t0, $a1      # i += 4
	j loopi
	

printVet:
	beq $t0, $s1, end      # parada da impressão (i == 4*MAX)
	li $v0, 1              # imprime vet[t0]
	lw $a0, array($t0)     # load vet[t0]
	syscall
	
	li $v0, 4	       #imprime um espaço
	la $a0, espaco
	syscall

	add $t0, $t0, $a1      # i += 4
	j printVet


end:
	li $v0, 10
	syscall