DEADBEEF in MIPS
Magic Numbers: 0x1224, 3333, 9671
The max number can be as large as 2^32 bits. The limit is determined by the number of bits for an integer.
The range of the addresses are 0x10010000 to 0x10010024
The pseudo-ops I used were Load Immediate, Load Address, Branch Less than or Equal to. Load immediate is converted to addiu, load address is converted to lui, ble is converted to slt. The conversion happens automatically in Mars.
I used 8 register. $a0, $v0, %t0-5. I think I can use less register since some numbers are handled once only, and can be overwritten without worry about losing data.
