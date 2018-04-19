Lang Li
Vigenere Cipher
Professor provided the encryption test code. I wrote the decryption test code. I need to test if my decryption works as intended. It did work out pretty well.
If user attempts to encrypt keystring with illegal character, it will encrypt the character with faults. This code is written under the assumption that the key string only contains capitalized alphabets. It will still go through the process of encrypting the plain text with upper case keys but the keys are not legal characters.
If I would write a recursive subroutine, I would write it similar to a loop, but changing the value that needs to be manipulation further to the result value in the register. Under the condition that the value at target register did not meet the requirement. Only branch out if the condition is met and carry on with the subroutine.
Using the $s register should be sufficient for storing passed registers since it won't be overwritten unless explicitly told to do so.
