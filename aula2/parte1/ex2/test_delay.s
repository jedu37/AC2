#Mapa de Registos
# counter -> $s0

        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ PUT_CHAR,3
        .equ PRINT_INT,6

        .data
        .text
        .globl main

main:   addiu $sp,$sp,-8                # Reservar espaço na StacK
        sw $s0, 0($sp)			        # Guardar $s0 na Stack
        sw $ra, 4($sp)			        # Guardar $ra na Stack
        
        li $s0,0                        # int counter = 0;

while:  li $a0,10                       #
        jal delay                       # delay(10) f=1/0,01 = 100 Mhz e 0,01 s = 10 ms

        addi $s0,$s0,1                  #   counter++;

        move $a0,$s0                    #
        li $a1,0x0004000A               #
        li $v0,PRINT_INT                #
        syscall                         #   printInt(counter, 10 | 4 << 16);

        li $a0,'\r'                     #
        li $v0,PUT_CHAR                 #
        syscall                         #   putChar('\r');
        j while                         # }

        lw $s0, 0($sp)			        # Restaurar $s0 a partir da Stack
        lw $ra, 4($sp)			        # Restaurar $ra a partir da Stack
        addiu $sp,$sp,8                 # Libertar espaço na StacK

        li $v0,1                        # return 0;
        jr $ra                          # }        