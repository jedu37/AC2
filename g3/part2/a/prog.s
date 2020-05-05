        .equ SFR_BASE_HI, 0xBF88 # 16 MSbits of SFR area
        .equ TRISE, 0x6100 # TRISE address is 0xBF886100
        .equ LATE, 0x6120 # LATE address is 0xBF886120
        .equ TRISB, 0x6040 # TRISB address is 0xBF886100
        .equ PORTB, 0x6050 # PORTB address is 0xBF886110
        .equ resetCoreTimer,12
        .equ readCoreTimer,11

        .data
        .text
        .globl main

main:   move $s0,$ra

        li $t0,0
        li $t5,16
        
        lui $t1, SFR_BASE_HI #
        lw $t2, TRISE($t1) # READ (Mem_addr = 0xBF880000 + 0x6100)
        andi $t2, $t2, 0xFFF0 # 4 Bits as Output
        sw $t2, TRISE($t1) # WRITE (Write TRISE register)

        lw $t3, TRISB($t1) # READ (Mem_addr = 0xBF880000 + 0x6040)
        ori $t3, $t3, 0x000F # 4 Bits as Input
        sw $t3, TRISB($t1) # WRITE (Write TRISB register)

        lw $t4,LATE($t1) # READ (Mem_addr = 0xBF880000 + 0x6120)
        andi $t4, $t4, 0xFFF0 # 4 Bits = 0
        sw $t4, LATE($t1) # WRITE (Write LATE register)

while:  li  $a0,500
        jal	delay				# jump to delay and save position to $ra

        addi	$t0, $t0,1			# $t0 = $t0 + 1

        div		$t0, $t5			# $t0 / $t1
        mfhi	$t6				# $t3 = $t0 mod $t1 

        andi $t4,$t4, 0xFFF0 # 4 Bits = 0
        or   $t4,$t6 # 4 Bits do counter
        sw   $t4,LATE($t1) # WRITE (Write LATE register)
        
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