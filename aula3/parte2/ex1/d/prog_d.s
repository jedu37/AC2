        .equ SFR_BASE_HI, 0xBF88            # 16 MSbits of SFR area
        .equ TRISE, 0x6100                  # TRISE address is 0xBF886100
        .equ LATE, 0x6120                   # LATE address is 0xBF886120
        .equ TRISB, 0x6040                  # TRISB address is 0xBF886040
        .equ PORTB, 0x6050                  # PORTB address is 0xBF886050
        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ PRINT_INT,6

        .data
        .text
        .globl main
main:   addiu $sp,$sp,-12                    # Reservar espaço na stack
        sw $s0,0($sp)                       # Guardar $s0 na stack
        sw $s1,4($sp)                       # Guardar $s1 na stack
        sw $ra,8($sp)                       # Guardar $ra na stack

        lui $s0, SFR_BASE_HI                #
        lw $t0, TRISE($s0)                  # READ (Read TRISE register)
        andi $t0, $t0, 0xFFF0               # MODIFY (bit0,bit1,bit2,bit3=0 (0 means OUTPUT))
        sw $t0, TRISE($s0)                  # WRITE (Write TRISE register)

        lw $t0, TRISB($s0)                  # READ (Read TRISB register)
        ori $t0, $t0,0x000F                 # MODIFY (bit0,bit1,bit2,bit3=1 (1 means INPUT))
        sw $t0, TRISB($s0)                  # WRITE (Write TRISB register)

        li $s1,0x0000                            # counter = 0

while:  li $a0,666                          #while(True){
        jal delay                           # delay(1000)

        rem $t0,$s1,16                      # $t0 = counter %16


mid:    lw $t1, LATE($s0)                   # Read LATE
        andi $t1, $t1, 0xFFF0               # LATE_bit0,1,2,3 = 0
        or $t1,$t1,$t0                      # LATE_bit0 = PortB./bit3.bit2.bit1./bit0
        sw $t1, LATE($s0)                   # WRITE LATE  


        andi   $t2, $t1, 0x0008         #               $t2 = RE3
        srl     $t2, $t2, 3             #               goes to LSB
        sll     $s1, $s1, 1             #               count = count << 1
        xori    $t2, $t2, 0x0001        #               $t2 = RE3\
        or      $s1, $s1, $t2           #               first bit of count = RE3\
        andi    $s1, $s1, 0x000F        #               count &= 0x000F

        j while                             #}

        lw $s0,0($sp)                       # Recuperar $s0 da stack
        lw $s1,4($sp)                       # Recuperar $ra da stack
        lw $ra,8($sp)                       # Recuperar $ra da stack
        addiu $sp,$sp,12                    # Libertar  espaço na stack

        li $v0,0                            # return 0;
        jr $ra                              #}

#--Functions--

delay:  move $t0,$a0                # ms = $t0 = $a0

for_d:  ble $t0, 0, end_d	    # for(ms > 0){

        li $v0,RESET_CORE_TIMER     #
        syscall                     #   resetCoreTimer();

while_d:        li $v0,READ_CORE_TIMER      # 
                syscall                     #
                blt $v0,20000,while_d       #   while(readCoreTimer() < K);

                sub $t0, $t0, 1	            #   ms--;
                j for_d                     # }

end_d:    jr $ra
