###########################################
# data section:
# user prompt for entering the number
# finished prompt for displaying the input number
# ending message when the code in finished
# new line for printing a new line
# text section:
# print out the user prompt
# take in the number input as program argument
# if it is a negative number 
# not the entire series of bits
# add 1 to the bits
# else just store at $s0
# convert it to binary
# use rotation to rotate the bit to the first bit so the pointer will point to the next bit to store and print
# print out $s0 in binary
###########################################
.data 
	userPrompt: .asciiz "User input number:"
	finishedPrompt: .asciiz "This number in binary is:"
	fin: .asciiz "-- program is finished running --"
	newLine: .asciiz "\n"
.text
	#user prompt
	li $v0, 4
	la $a0, userPrompt
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	
	#get user input from program argument, then start loading in the word
	lw $s2, ($a1) #load the entire word to $s1
	lb $s1, ($s2) #load one character to register
	bne $s1, 45, loop #if the first character is not a - or a subtract sign jump straight to convertion
	add $s2, $s2, 1 #add one bit to input
	lb $s1, ($s2) #load the byte to $s2
	add $t5, $t5, 1 #flag that the number is negative
loop: 
	sub $s1 $s1, 48 #subtract 48 ascii value to get the numerical ascii representation
	mul $t1, $t1, 10 #make space for the next byte
	addu $t1, $t1, $s1
	add $s2, $s2, 1
	lb $s1, ($s2)	
	bne $s1, 0, loop
bge $t1, 0, temp #makes sure if its positive
bgt $t1, -2147483648, terminate #makes sure within bounds
bne $t5, 1, terminate #makes sure if its suppose to be negative
	not $t1, $t1
	addu $t1, $t1, 1
temp: 
beq $t5, 0, positive
	not $t1, $t1
	addu $t1, $t1, 1 
	#if positive just print out the number
positive: 
	li $v0, 1
	la $a0, ($t1)
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $t2, 1
	li $t4, 1
	
	#print out the number in program argument
	li $v0, 4
	la $a0, finishedPrompt
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	#print out the number in binary
loop2:
	rol $t1, $t1, 1
	and $t3, $t2, $t1
	
	li $v0, 1
	la $a0, ($t3)
	syscall 
	
	add $t4 $t4, 1
	sll $s0, $s0, 1
	add $s0, $s0, $t3
	ble $t4, 32, loop2
		
terminate:
	#terminate code
	li $v0, 10
	syscall
