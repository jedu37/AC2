#Mapa de Registos
# cnt10 -> $s0
# cnt5 -> $s1
# cnt1 -> $s2

        .equ printInt,6
        .equ putChar,3
        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12

        .data
        .text
        .globl main

main:   addiu $sp,$sp,-20           #Reservar Espaço na Stack
        sw $s0,0($sp)               # Salvar os Registos
        sw $s1,4($sp)               # 
        sw $s2,8($sp)               #
        sw $s3,12($sp)              # 
        sw $ra,16($sp)              # 

        li $s0,0                    # cnt10 = 0
        li $s1,0                    # cnt5 = 0
        li $s2,0                    # cnt1 = 0

while:                              # while(1){
        li $a0,100                  #
        move $a1,$s3                #
        jal timeDone                #
        move $s3,$v0                #
        beq $s3,0,while             #

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
        addi $s0,$s0,1              # cnt10++;

if1:    rem $t0,$s0,2               #
        bnez $t0,if2                # if(cnt10 % 2 == 0){
        addi $s1,$s1,1              #       cnt5++;
                                    #}

if2:    rem $t0,$s0,10              #
        bnez $t0,skip1              # if(cnt10 %10 == 0){
        addi $s2,$s2,1              #       cnt1++;
        li $a0,'\n'                 #
        li $v0,putChar              #
        syscall                     # putChar('\n');


                                    #}
skip1:

        j while                     # }
#Ending--------------------------------------------------------
        lw $s0,0($sp)               # 
        lw $s1,4($sp)               # 
        lw $s2,8($sp)               # 
        lw $s3,12($sp)              # 
        lw $ra,16($sp)              # 
        addiu $sp,$sp,16            #Libertar Espaço na Stack
        li $v0,0                    # return 0;
        jr $ra                      #}

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