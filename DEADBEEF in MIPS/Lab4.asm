.data 
out: .asciiz "Please enter a number N: "
newline: .asciiz "\n"
dead: .asciiz "DEAD"
beef: .asciiz "BEEF"
.text 
main:
	li $v0, 4
	la $a0, out
	syscall
	#output the out string
	li $v0, 5
	syscall
	move $t0, $v0
	#get user input integer for the loop
	
	li $t1, 1 #the i in a for loo
	loop: 
	#loop through user input
	li $t6, 0
	li $t2, 4
	li $t4, 9
	#the numbers that we need to compare to
	div $t1,  $t2
	mfhi $t3
	beq $zero, $t3, D
	d1: 
	#check if t1 is divisible by 4
	
	div $t1, $t4
	mfhi $t5
	beq $zero, $t5, B
	b1:
	#check if t1 is divisible by 9
	
	beq $t6, $zero, N
	n1:
	#if not divisible by 4 or 9, just print number
	
	li $v0, 4
	la $a0, newline
	syscall 
	#print new line
	
	addi $t1, $t1, 1
	#increment t1
	
	ble $t1, $t0, loop
	#jump back to the loop label
	
	li $v0, 10
	syscall
	#terminate code
D:
	li $v0, 4
	la $a0, dead
	syscall
	add $t6, $t6, 1
	j d1 # jump back to loop after printing DEAD
B:
	li $v0, 4
	la $a0, beef
	syscall
	add $t6, $t6, 1
	j b1 # jump back to loop after printing BEEF
N:
	li $v0, 1
	move $a0, $t1
	syscall
	j n1 # jump back to loop after printing number