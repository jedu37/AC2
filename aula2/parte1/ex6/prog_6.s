#Mapa de Registos
# cnt10 -> $s0
# cnt5 -> $s1
# cnt1 -> $s2
# s -> $s3
# flag -> $s4

        .equ printInt,6
        .equ putChar,3
        .equ inKey,1
        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12

        .data
        .text
        .globl main

main:   addiu $sp,$sp,-24           #Reservar Espaço na Stack
        sw $s0,0($sp)               # Salvar os Registos
        sw $s1,4($sp)               # 
        sw $s2,8($sp)               # 
        sw $s3,12($sp)              #
        sw $s4,16($sp)              #
        sw $ra,20($sp)              #

        li $s0,0                    # cnt10 = 0
        li $s1,0                    # cnt5 = 0
        li $s2,0                    # cnt1 = 0
        li $s3,0                    # s = 0
        li $s4,0                    # flag = 0

while:                              # while(1){

if5:    bne $s3,0,if6               #if(s == 0){
        li $a0,100                  #
        jal delay                   # delay(100);
        j skip3                     #}

if6:    bne $s3,1,skip3             # else if(s == 1){
        li $a0,50                   #
        jal delay                   # delay(50);
                                    #}
skip3:  
        

#PRINTING------------------------------------------------------
        li $a0,'\r'                 #
        li $v0,putChar              #
        syscall                     # putChar('\r');

        move $a0,$s2                  #
        li $a1,0x00050002           #
        li $v0,printInt             #
        syscall                     # printInt(cnt1, 2 | 5 << 16);

        li $a0,' '                  #
        li $v0,putChar              #
        syscall                     # putChar(' ');

        move $a0,$s1                  #
        li $a1,0x00050002           #
        li $v0,printInt             #
        syscall                     # printInt(cnt5, 2 | 5 << 16);

        li $a0,' '                  #
        li $v0,putChar              #
        syscall                     # putChar(' ');

        move $a0,$s0                  #
        li $a1,0x00050002           #
        li $v0,printInt             #
        syscall                     # printInt(cnt10, 2 | 5 << 16);


#Incrementig---------------------------------------------------
if7:    bne $s4,0,skip1             # if(flag == 0){

        addi $s0,$s0,1              #   cnt10++;

if1:    rem $t0,$s0,2               #
        bnez $t0,if2                #   if(cnt10 % 2 == 0){
        addi $s1,$s1,1              #       cnt5++;
                                    #   }

if2:    rem $t0,$s0,10              #
        bnez $t0,skip1              #   if(cnt10 %10 == 0){
        addi $s2,$s2,1              #       cnt1++;
                                    #   }
                                    # }
skip1:  li $v0,inKey                #
        syscall                     #
        move $t0,$v0                # char c = inkey();

if3:    bne $t0,'a',if4             # if(c == 'a'){
        li $s3,1                    #   s = 1;
        j skip2                     # } 

if4:    bne $t0,'n',if8             # if(c == 'n'){
        li $s3,0                    #   s = 0;
        j skip2                     # }

if8:    bne $t0,'s',if9             # if(c == 's'){
        li $s4,1                    #   flag = 1;
        j skip2                     # }                            # }  

if9:    bne $t0,'r',skip2           # if(c == 'r'){
        li $s4,0                    #   s = 0;
                                    # }  

skip2:
        j while                     # }
#Ending--------------------------------------------------------
        lw $s0,0($sp)               # 
        lw $s1,4($sp)               # 
        lw $s2,8($sp)               #
        lw $s3,12($sp)              #  
        lw $s4,16($sp)              #  
        lw $ra,20($sp)              # Restaurar registos
        addiu $sp,$sp,24            #Libertar Espaço na Stack
        li $v0,0                    # return 0;
        jr $ra                      #}                         #}     

delay:  move $t0,$a0                # ms = $t0 = $a0

for_d:  ble $t0, 0, end_d	    # for(ms > 0){

        li $v0,RESET_CORE_TIMER     #
        syscall                     #   resetCoreTimer();

while_d:        li $v0,READ_CORE_TIMER      # 
                syscall                     #
                blt $v0,20000,while_d       #   while(readCoreTimer() < K);

                sub $t0, $t0, 1	            #   ms--;
                j for_d                     # }

end_d:    jr $ra                      #}    
