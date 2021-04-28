        .globl main
        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ PUT_CHAR,3
        .equ PRINT_INT,6

        .data
        .text
        .globl main

main:   addiu $sp,$sp,-12                # Stack Save
        sw $s0,0($sp)                    #
        sw $s1,4($sp)                    #
        sw $ra,8($sp)                    #

        li $s1,0                         #
while:  
        li $a0,1000                     # ms = 1000;
        move $a1,$s0                    # reset = previous val
        jal timeDone                    #
        move $s0,$v0                    # val = TimeDone(ms,reset)
        beq $s0,0,while                 #

        addiu $s1,$s1,1                 #

        move $a0,$s1                    #
        li $a1,0x0004000A               #
        li $v0,PRINT_INT                #
        syscall                         #   printInt(counter, 10 | 4 << 16);

        li $a0,'\r'                     #
        li $v0,PUT_CHAR                 #
        syscall                         #   putChar('\r');
        j while                         # }

        lw $s0,0($sp)                   #
        lw $ra,4($sp)                   #
        addiu $sp,$sp,8                 # Stack Clean

        li $v0,1                        # return 0;
        jr $ra                          # }

#TIMEDONE

#Mapa de Registos
# $t0 -> curCount
# $t1 -> retValue
# $t2 -> (ms* 20000)

timeDone:                               #unsigned int timeDone(int ms, unsigned char reset)
                                        #{
            li $t1,0                    #   unsigned int retValue = 0;

            li $t3,20000                #
            mul $t2,$a0,$t3             #   $t2 = (ms* 20000)
            

            ble $a1,0,else_td           #   if (reset > 0)
                                        #   {
            li $v0,RESET_CORE_TIMER     #
            syscall                     #       resetCoreTimer();
                                        #   }
else_td:                                #   else
                                        #   {
            li $v0,READ_CORE_TIMER      #
            syscall                     #
            move $t0,$v0                #       curCount = readCoreTimer();
            ble $t0,$t2,end_td          #       if (curCount > (ms * 20000))
            div $v0,$t0,$t3             #           retValue = curCount / 20000;
            jr $ra                      #   }
end_td:     li $v0,0                    #   return retValue;
            jr $ra                      #}