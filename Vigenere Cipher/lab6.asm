.text
# Subroutine EncryptChar
# Encrypts a single character using a single key character.
# input: $a0 = ASCII character to encrypt
# $a1 = key ASCII character
# output: $v0 = Vigenere-encrypted ASCII character
# Side effects: None
# Notes: Plain and cipher will be in alphabet A-Z or a-z
# key will be in A-Z
# pseudoCode:
# load the char of string and key to t0 and t1
# create a temp variable for calculation because overflowing div is too picky
# if(strChar >= 65 AND strChar <= 90) it is an upper case letter
# if(strChar >= 97 AND strChar <= 122) it is a lower case letter
# else it is not a letter, jump to notEncryptable
# use the formula E = (P + K) mod 26 to perform calculation on plain text
# I found this formula via Google
# put the results to v0
# notEncryptable:
# just copy the original strChar to v0 and return
# return
EncryptChar:
	move $t0, $a0 #load char from a0 to s1
	#lb $s2, ($s1) #load one byte from the word to s2
	move $t1, $a1 #load the key to from a1 to s2
	li $s1, 26 #create temp variable with 26 to get remainder
	bge $t0, 65, checkUpperCaseLowerBound #if this char is greater than or equal to 65 in ascii, check lower bound
	j notEncryptable
	checkUpperCaseLowerBound:
		ble $t0, 90, upperCase #if the ascii is less than or equal to 90, its an upper case letter
	bge $t0, 97, checkLowerCaseLowerBound #if the ascii is greater or equal than 97, its an lower case letter
	checkLowerCaseLowerBound:
		ble $t0, 122, lowerCase
	j notEncryptable #if its not an alphabet, its not encryptable
	upperCase:
		sub $t2, $t0, 65 #subtract 65 from plain text to get numerical representation of letter, stored in t2
		sub $t3, $t1, 65 #subtract 65 from key to get acutal amount to shift, stored in t3
		add $t4, $t2, $t3 #add the two numbers to get the new numerical represention of new letter
		div $t4, $s1
		mfhi $t6
		add $v0, $t6, 65 #add 65 back to the resulting number to get new letter, store result in v0
		j return
	lowerCase:
		sub $t2, $t0, 97 #subtract 97 from plain text to get nunmerical representation of letter stored in t2
		sub $t3, $t1, 65 #subtract 65 from key to get amount of shifts needed to encrypt, stored t3
		add $t4, $t2, $t3 #add the two numbers to get the numerical representation of the new letter, stored in t4
		div $t4, $s1 #divide the new number by 26 to get the remainder
		mfhi $t6 #get remainder
		add $v0, $t6, 97 #add 97 back to the resulting number to get new letter, store result in v0
		j return
	notEncryptable: #do nothing about the char if its not encryptable
		move $v0, $t0
	return: #return label to jump back to whoever called it
		jr $ra #jump back to caller

# Subroutine DecryptChar
# Decrypts a single character using a single key character.
# input: $a0 = ASCII character to decrypt
# $a1 = key ASCII character
# output: $v0 = Vigenere-decrypted ASCII character
# Side effects: None
# Notes: Plain and cipher will be in alphabet A-Z or a-z
# key will be in A-Z
# pseudoCode:
# load the char of string and key to t0 and t1
# create a temp variable for calculation because overflowing div is too picky
# if(strChar >= 65 AND strChar <= 90) it is an upper case letter
# if(strChar >= 97 AND strChar <= 122) it is a lower case letter
# else it is not a letter, jump to notDecryptable
# use the formula P = (E - K + 26) mod 26 to perform calculation of encrypted cipher
# I found this formula via Google
# put the results to v0
# notDecryptable:
# just copy the original strChar to v0 and return
# return

DecryptChar:
	move $t0, $a0 #load char from a0 to s1
	#lb $s2, ($s1) #load one byte from the word to s2
	move $t1, $a1 #load the key to from a1 to s2
	li $s1, 26 #create temp variable with 26 to get remainder
	bge $t0, 65, checkUCLB #if this char is greater than or equal to 65 in ascii, check lower bound
	j notDecryptable
	checkUCLB:
		ble $t0, 90, upperC #if the ascii is less than or equal to 90, its an upper case letter
	bge $t0, 97, checkLCLB #if the ascii is greater or equal than 97, its an lower case letter
	checkLCLB:
		ble $t0, 122, lowerC
	j notDecryptable #if its not an alphabet, its not encryptable
	upperC:
		sub $t2, $t0, 65 #subtract 65 from cipher text to get numerical representation of letter, stored in t2
		sub $t3, $t1, 65 #subtract 65 from key to get acutal amount to shift, stored in t3
		sub $t4, $t2, $t3 #subtract the two numbers to get
		add $t4, $t4, 26
		div $t4, $s1
		mfhi $t6
		add $v0, $t6, 65 #add 65 back to the resulting number to get new letter, store result in v0
		j returnD
	lowerC:
		sub $t2, $t0, 97 #subtract 97 from cipher text to get nunmerical representation of letter stored in t2
		sub $t3, $t1, 65 #subtract 65 from key to get amount of shifts needed to encrypt, stored t3
		sub $t4, $t2, $t3 #add the two numbers to get the numerical representation of the new letter, stored in t4
		add $t4, $t4, 26
		div $t4, $s1 #divide the new number by 26 to get the remainder
		mfhi $t6 #get remainder
		add $v0, $t6, 97 #add 97 back to the resulting number to get new letter, store result in v0
		j returnD
	notDecryptable: #do nothing about the char if its not encryptable
		move $v0, $t0
	returnD: #return label to jump back to whoever called it
		jr $ra #jump back to caller

# Subroutine EncryptString
# Encrypts a null-terminated string of length 30 or less,
# using a keystring.
# input: $a0 = Address of plaintext string
# $a1 = Address of key string
# $a2 = Address to store ciphertext string
# output: None
# Side effects: String at $a2 will be changed to the
# Vigenere-encrypted ciphertext.
# $a0, $a1, and $a2 may be altered
# pseudoCode:
# copy $ra to temp variable so jr $ra from encryptChar won't mess with it
# load the address of string and key to t9 and t8
# copy the first byte address of key just in case if wrap around is needed
# load the first byte of string and key to a0 and a1 for encryptChar
# while(a0 is not NULL)
#	call EncryptChar
#	if(v0 != a0)
#		increment key pointer and load the next byte of key
#	store the encrypted char to a0 and increment a0 pointer to make space for the next char
#	increment string pointer and load the next byte of string
#	if(a1 is NULL)
#		overwrite current t8 with s2 and load that char to a1
# copy the original ra back to ra
# return
EncryptString:
	move $t7, $ra
	la $t9, ($a0) #load the string address to s2
	la $t8, ($a1) #load the key address to s3
	move $s2, $t8 #copy the address of the first byte of key to separatet address for special cases
	lb $a0, ($t9) #load the first byte from plain text
	lb $a1, ($t8) #load the first byte from key
	encryptLoop:
		jal EncryptChar #call encryptChar
		beq $v0, $a0, NoKeyInc
			add $t8, $t8, 1 #increment key ptr
			lb $a1, ($t8) #load the next byte of the key
		NoKeyInc:
		sb $v0, ($a2)
		add $a2, $a2, 1

		add $t9, $t9, 1 #increment string ptr
		lb $a0, ($t9) #load the next byte of the string

		bgt $a1, 1, back #if the current byte in key is null, jump to reset pointer
			move $t8, $s2 #set s3 pointer to s6, where s6 is always pointing to the first byte of the key
			lb $a1, ($t8)
		back:
	bne $a0, 0, encryptLoop #keep going on the loop until string pointer hits null
	move $ra, $t7
	jr $ra

# Subroutine DecryptString
# Encrypts a null-terminated string of length 30 or less,
# using a keystring.
# input: $a0 = Address of ciphertext string
# $a1 = Address of key string
# $a2 = Address to store plaintext string
# output: None
# Side effects: String at $a2 will be changed to the
# Vigenere-decrypted plaintext
# $a0, $a1, and $a2 may be altered
# pseudoCode:
# copy $ra to temp variable so jr $ra from encryptChar won't mess with it
# load the address of string and key to t9 and t8
# copy the first byte address of key just in case if wrap around is needed
# load the first byte of string and key to a0 and a1 for encryptChar
# while(a0 is not NULL)
#	call DecryptChar
#	if(v0 != a0)
#		increment key pointer and load the next byte of key
#	store the decrypted char to a0 and increment a0 pointer to make space for the next char
#	increment string pointer and load the next byte of string
#	if(a1 is NULL)
#		overwrite current t8 with s2 and load that char to a1
# copy the original ra back to ra
# return
DecryptString:
	move $t7, $ra #copy the address of ra to separate register to prevent the jr $ra from decrypChar messing it up
	la $t9, ($a0) #load the string address to s2
	la $t8, ($a1) #load the key address to s3
	move $s2, $t8 #copy the address of the first byte of key to separatet address for special cases
	lb $a0, ($t9) #load the first byte from plain text
	lb $a1, ($t8) #load the first byte from key
	decryptLoop:
		jal DecryptChar #call DecryptChar
		beq $v0, $a0, NoKeyIncD #if the value returned from DecryptChar is the same as input, that means this char is not alphabet
			add $t8, $t8, 1 #increment key ptr
			lb $a1, ($t8) #load the next byte of the key
		NoKeyIncD:
		sb $v0, ($a2)
		add $a2, $a2, 1

		add $t9, $t9, 1 #increment string ptr
		lb $a0, ($t9) #load the next byte of the string

		bgt $a1, 1, backD #if the current byte in key is null, jump to reset pointer
			move $t8, $s2 #set s3 pointer to s6, where s6 is always pointing to the first byte of the key
			lb $a1, ($t8) #load the next byte of key to a1
		backD:
	bne $a0, 0, decryptLoop #keep going on the loop until string pointer hits null
	move $ra, $t7
	jr $ra
