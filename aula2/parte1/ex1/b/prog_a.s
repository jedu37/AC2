        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ PUT_CHAR,3
        .equ PRINT_INT,6

        .data
        .text
        .globl main

main:   li $t0,0                        # int counter = 0;
while:  li $v0,READ_CORE_TIMER          # while (1) {
        syscall                         #
        blt $v0,200000,while            #   while(readCoreTimer() < 200000);
        li $v0,RESET_CORE_TIMER         #   
        syscall                         #   resetCoreTimer(); 

        addi $t0,$t0,1                  #   counter++;

        move $a0,$t0                    #
        li $a1,0x0004000A               #
        li $v0,PRINT_INT                #
        syscall                         #   printInt(counter, 10 | 4 << 16);

        li $a0,'\r'                     #
        li $v0,PUT_CHAR                 #
        syscall                         #   putChar('\r');
        j while                         # }

        li $v0,1                        # return 0;
        jr $ra                          # }        