#$s0: so kwh
#$s1: dia chi mang kWh_bac
#$s2: dia chi mang Don_gia
#$s3: tong
#$s4: index i
#$s5: so bac n
#$s6: luu nguong tren truoc de tinh width cua bac hien tai
#$t0: xet dieu kien xem coi co can nhap lai hay khong
#$t1: i*4
#$t2: dia chi phan tu thu i cua mang kwh_bac va mang Don_gia
#$t3: luu gia tri phan tu i cua mang kwh_bac
#$t4: luu gia tri phan tu i cua mang Don_gia
#$t5: xet dieu kien giua nguong tren hien tai va so kwh
#$t6: kwh bac i * don_gia

.data
text1: .asciiz "Nhap so kWh (0..9999): "
text2: .asciiz "Gia tri khong hop le, nhap lai\n"
n: .word 6
kWh_bac:  .word 50, 100, 200, 300, 400, 9999 #luu nguong tren cua moi bac
Don_gia:  .word 1640, 1700, 1990, 2540, 2890, 3040
Tien_dien: .asciiz "Tien dien: "
Dong: .asciiz " dong\n"

.text
Main:
	la $s1, kWh_bac
	sll $s5, $s5, 2	#4n code thu 2
	add $s5, $s5, $s1 #con tro cuoi code thu 2
	lw $s5, n
	
nhap_kWh:
	li $v0, 4
	la $a0, text1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0

	sltiu $t0, $s0, 10000
	beq $t0, $zero, again

	li $s3, 0	#tong
	move $s4, $s1	#Con tro bat dau tu dau mang code thu 2
	li $s6, 0	#prev nguong tren
loop:
	beq $s4, $s5, print	#dieu kien ngung
	lw $t3, 0($s4)		
	lw $t4, 24($s4)
	
	slt $t5, $t3, $s0	#xet co phai nguong tren cuoi hay khong
	beq $t5, $zero, last
	
	sub $t6, $t3, $s6	#width cua bac i
	mul $t6, $t6, $t4	#kwh bac i * don_gia
	add $s3, $s3, $t6	#cap nhat tong
	move $s6, $t3		#cap nhat nguong tren truoc
	addi $s4, $s4, 4
	j loop
	
last:
	sub $t6, $s0, $s6	#so kwh - nguong tren truoc, phan kwh con lai
	mul $t6, $t6, $t4
	add $s3, $s3, $t6
	
print:
	li $v0, 4
	la $a0, Tien_dien
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, Dong
	syscall
	
	li $v0, 10
	syscall
again:
	li $v0, 4
	la $a0, text2
	syscall
	j nhap_kWh
