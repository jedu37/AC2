        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12

        .data
        .text
        .globl timeDone
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