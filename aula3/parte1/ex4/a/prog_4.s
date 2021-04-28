        .equ SFR_BASE_HI, 0xBF88            # 16 MSbits of SFR area
        .equ TRISE, 0x6100                  # TRISE address is 0xBF886100
        .equ LATE, 0x6120                   # LATE address is 0xBF886120
        .equ TRISB, 0x6040                  # TRISB address is 0xBF886040
        .equ PORTB, 0x6050                  # PORTB address is 0xBF886050
        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12

        .data
        .text
        .globl main

#Mapa de registos
# $s1 -> v

main:   addiu $sp,$sp,-12                   # Reservar espaço na stack
        sw $s0,0($sp)                       # Guardar $s0 na stack
        sw $s1,4($sp)                       # Guardar $s1 na Stack
        sw $ra,8($sp)                       # Guardar $ra na stack

                                            #void main(void)
                                            #{
        li $s1,0                            #   int v = 0;
        lui $s0, SFR_BASE_HI                #
                                            #   TRISE0 = 0; // Configura o porto RE0 como saída
        lw $t0, TRISE($s0)                  #   READ (Read TRISE register)
        andi $t0, $t0, 0xFFFE               #   MODIFY (bit0 = 0 (0 means OUTPUT))
        sw $t0, TRISE($s0)                  #   WRITE (Write TRISE register)
while:                                      #   while(1)
                                            #   {
        lw $t1,LATE($s0)                    #       Read LATE
        andi $t1,$t1,0xFFFE                 #       LATE_bit0 = 0
        or $t1,$t1,$s1                      #       LATE_bit0 = v
        sw $t1, LATE($s0)                   #       WRITE LATE  #LATE0 = v; // Escreve v no bit 0 do porto E
        
        li $a0,500                          #
        jal delay                           #       delay(500); // Atraso de 500ms
        xor $s1,$s1,0x0001                  #       v ^= 1; // complementa o bit 0 de v (v = v xor 1)
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
    