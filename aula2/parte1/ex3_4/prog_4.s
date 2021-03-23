#Mapa de Registos
# cnt10 -> $s0
# cnt5 -> $s1
# cnt1 -> $s2

        .equ printInt,6
        .equ putChar,3

        .data
        .text
        .globl main

main:   addiu $sp,$sp,-16           #Reservar Espaço na Stack
        sw $s0,0($sp)               # Salvar os Registos
        sw $s1,4($sp)               # 
        sw $s2,8($sp)               # 
        sw $ra,12($sp)              # 

        li $s0,0                    # cnt10 = 0
        li $s1,0                    # cnt5 = 0
        li $s2,0                    # cnt1 = 0

while:                              # while(1){
        li $a0 100                  #
        jal delay                   # delay(100)

#PRINTING------------------------------------------------------
        li $a0,'\r'                 #
        li $v0,putChar              #
        syscall                     # putChar('\r');

        li $a0,$s2                  #
        li $a1,0x00050002           #
        li $v0,printInt             #
        syscall                     # printInt(cnt1, 2 | 5 << 16);

        li $a0,' '                  #
        li $v0,putChar              #
        syscall                     # putChar(' ');

        li $a0,$s1                  #
        li $a1,0x00050002           #
        li $v0,printInt             #
        syscall                     # printInt(cnt5, 2 | 5 << 16);

        li $a0,' '                  #
        li $v0,putChar              #
        syscall                     # putChar(' ');

        li $a0,$s0                  #
        li $a1,0x00050002           #
        li $v0,printInt             #
        syscall                     # printInt(cnt10, 2 | 5 << 16);


#Incrementig---------------------------------------------------
        addi $s0,$s0,1              # cnt10++;

if1:    rem $t0,$s0,2               #
        bnez $t0,if2                # if(cnt10 % 2 == 0){
        addi $s1,$s1,1              #       cnt5++;
                                    #}

if2:    rem $t0,$s0,10              #
        bnez $t0,skip1              # if(cnt10 %10 == 0){
        addi $s2,$s2,1              #       cnt1++;
                                    #}
skip1:

        j while                     # }
#Ending--------------------------------------------------------
        lw $s0,0($sp)               # 
        lw $s1,4($sp)               # 
        lw $s2,8($sp)               # 
        lw $ra,12($sp)              # Restaurar registos
        addiu $sp,$sp,16            #Libertar Espaço na Stack
        li $v0,0                    # return 0;
        jr $ra                      #}     