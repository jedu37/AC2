        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ PUT_CHAR,3
        .equ PRINT_INT,6

        .data
        .text
        .globl main

main:   move $s1,$ra
        li $t0,0                            # int counter = 0;

while:  li $v0,1                    
        syscall
        beq $v0,'x',end

        li $a0,500
        jal delay

        li $a0,' '                          #
        li $v0,PUT_CHAR                     #
        syscall                             # putChar('\r');

        addi $t0,$t0,1                      #
        move $a0,$t0                        #
        li $a1,10                           #
        li $v0,PRINT_INT                    #
        syscall                             # printInt(++counter, 10);

        j while                             #

end:    move $ra,$s1                        # }
        jr $ra # 

delay:  move $t1,$a0
        li      $t3,20000
        mult	$t1, $t3			# $t1 *$t3 = Hi and Lo registers
        mflo	$t2					# copy Lo to $t2

        li $v0,RESET_CORE_TIMER             #
        syscall                             # resetCoreTimer();

loop:   li $v0,READ_CORE_TIMER              # while (1) {
        syscall                             #
        
        blt $v0,$t2,loop                    # while(readCoreTimer() < 200000);
        li $v0,RESET_CORE_TIMER             #
        syscall                             # resetCoreTimer();
                
        jr $ra #