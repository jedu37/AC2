        .equ resetCoreTimer,12
        .equ readCoreTimer,11
        .equ SFR_BASE_HI, 0xBF88 # 16 MSbits of SFR area
        .equ TRISE, 0x6100 # TRISE address is 0xBF886100
        .equ LATE, 0x6120 # LATE address is 0xBF886120

        .data
        .text
        .globl main

main:   move $s0,$ra #Guardar o endereço de final
        
        lui $t1, SFR_BASE_HI #
        lw $t2, TRISE($t1) # READ (Mem_addr = 0xBF880000 + 0x6100)
        andi $t2, $t2, 0xFFFE # Bit as Output
        sw $t2, TRISE($t1) # WRITE (Write TRISE register)

        lw $t3, LATE($t1) # READ (Mem_addr = 0xBF880000 + 0x6120)
        andi $t3, $t3, 0xFFFE # RE0 = 1
        sw $t3, LATE($t1) # WRITE (Write LATE register)

while:  li $v0,1                    
        syscall
        beq $v0,'x',end

        li $a0, 5000
        jal delay

        xor $t3,0x0001 # RE0 = \RE0
        sw $t3, LATE($t1) # WRITE (Write LATE register)
        j while


end:    move $ra,$s0
        li   $v0,0 # return 0;
        jr   $ra

delay:  move $s1,$a0
        li      $s3,20000
        mult	$s1, $s3			# $t1 *$t3 = Hi and Lo registers
        mflo	$s2					# copy Lo to $t2

        li $v0,resetCoreTimer             #
        syscall                             # resetCoreTimer();

loop:   li $v0,readCoreTimer              # while (1) {
        syscall                             #
        
        blt $v0,$s2,loop                    # while(readCoreTimer() < 200000);
                
        jr $ra #