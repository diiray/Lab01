#tham so a = 2
#tham so b = 4
#$s0: dia chi Cao_do
#$s1: dia chi Do_dai
#$s2: gia tri n
#$s3: index
#$s4: Tong du kien
#$t0: i*4
#$t1: dia chi phan tu thu i cua Cao_do va Do_dai
#$t2: Cao do thuc su
#$t3: thoi luong

.eqv PARAM_A 2
.eqv PARAM_B 4
.eqv PARAM_INSTR 0
.eqv PARAM_VOL 100

.data
Cao_do: .word 64 64 65 67 67 65 64 62 60 60 62 64 64 62 62
Do_dai: .word 2 2 2 2 2 2 2 2 2 2 2 2 3 1 4
n: .word 15
space: .asciiz " "
down: .asciiz "\n"
text1: .asciiz "Tong du kien (ms): "
text2: .asciiz "Thoi gian do duoc (ms): "

.text
main: 
	la $s0, Cao_do
	la $s1, Do_dai
	lw $s2, n
	li $s3, 0
	li $s4, 0
	
	#tinh 150 + 10*b
	li $t4, PARAM_B
	li $t5, 10
	mul $s6, $t4, $t5
	addi $s6, $s6, 150
	
	li $v0, 30
	syscall
	move $s5, $a0
loop:
	beq $s3, $s2, exit
	sll $t0, $s3, 2
	
	add $t1, $s0, $t0
	lw $t2, 0($t1)
	addi $t2, $t2, PARAM_A	#Cao do thuc su = Cao_do[i] + 2
	
	add $t1, $s1, $t0	
	lw $t3, 0($t1)
	mul $t3, $t3, $s6	#thoi luong
	
	add $s4, $s4, $t3	#cap nhat tong du kien
	
	li $v0, 1		#in cao do
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, space
	syscall
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, down
	syscall
	
	li $v0, 31
	move $a0, $t2
	move $a1, $t3
	li $a2, PARAM_INSTR
	li $a3, PARAM_VOL
	syscall
	
	li $v0, 32
	move $a0, $t3
	syscall
	
	addi $s3, $s3, 1
	j loop
	
exit:
	li $v0, 30
	syscall
	sub $s7, $a0, $s5
	
	li $v0, 4
	la $a0, text1
	syscall
	li $v0, 1
	move $a0, $s4
	syscall
	li $v0, 4
	la $a0, down
	syscall
	
	li $v0, 4
	la $a0, text2
	syscall
	li $v0, 1
	move $a0, $s7
	syscall
	
	li $v0, 10
	syscall
