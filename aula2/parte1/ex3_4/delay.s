# Mapa de Registos
# ms -> $a0 -> $t0

        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12

        .data
        .text
        .globl delay
delay:  move $t0,$a0                # ms = $t0 = $a0

for:    ble $t0, 0, end	            # for(ms > 0){

        li $v0,RESET_CORE_TIMER     #
        syscall                     #   resetCoreTimer();

while:  li $v0,READ_CORE_TIMER      # 
        syscall                     #
        blt $v0,20000,while         #   while(readCoreTimer() < K);

        sub $t0, $t0, 1	            #   ms--;
        j for                       # }

end:    jr $ra                      #}
        
        