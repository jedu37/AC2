 .equ SFR_BASE_HI, 0xBF88 # 16 MSbits of SFR area
        .equ TRISE, 0x6100 # TRISE address is 0xBF886100
        .equ LATE, 0x6120 # LATE address is 0xBF886120
        .equ TRISB, 0x6040 # TRISB address is 0xBF886100
        .equ PORTB, 0x6050 # PORTB address is 0xBF886110
        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12

        .data
        .text
        .globl main

main:   move $s0,$ra

        
        lui $t1, SFR_BASE_HI #
        lw $t2, TRISE($t1) # READ (Mem_addr = 0xBF880000 + 0x6100)
        andi $t2, $t2, 0xFFF0 # 4 Bits as Output
        sw $t2, TRISE($t1) # WRITE (Write TRISE register)

        lw $t3, TRISB($t1) # READ (Mem_addr = 0xBF880000 + 0x6040)
        ori $t3, $t3, 0x000F # 4 Bits as Input
        sw $t3, TRISB($t1) # WRITE (Write TRISB register)

while:  li $v0,1                    
        syscall
        beq $v0,'x',end

        li $v0,READ_CORE_TIMER              # while (1) {
        syscall                             #

        blt $v0,20000000,while              # while(readCoreTimer() < 200000);
        li $v0,RESET_CORE_TIMER             #
        syscall                             # resetCoreTimer();

        lw $t4,PORTB($t1) # READ (Mem_addr = 0xBF880000 + 0x6050)
        andi $t5,$t4,0X000F # Verificar valor de RB0
        lw $t6,LATE($t1) # (Mem_addr = 0xBF880000 + 0x6120)
        andi $t6,$t6, 0xFFF0 # MODIFY (RE0=0)
        ori $t6,$t6,0x0009 # MODIFY (RE0=1)
        xor   $t6,$t5 # Atribuir o valor negado de RB0 a RE0
        sw   $t6,LATE($t1) # WRITE (Write TRISB register)

        j  while

end:    move $ra,$s0
        li   $v0,0 # return 0;
        jr   $ra