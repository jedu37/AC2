        .equ printInt,6
        .equ putChar,3
        .equ resetCoreTimer,12
        .equ readCoreTimer,11

        .data
        .text
        .globl main

main:   move $s1,$ra

loop1:  lui $t1,0xBF88
        lw $t2,0x6050($t1)

        li      $t3,0

        addi	$t3, $t2,1
        li      $t4,1000
        div		$t4, $t3			# $t0 / $t1
        mflo	$t5					# $t2 = floor($t0 / $t1)

        move $a0,$t5
        li	 $a1,2
        li   $v0,7
        syscall      
        
        move $a0,$t5
        jal delay
        

        move $a0,$t2
        li $a1, 0x00040002
        li $v0,printInt
        #syscall

        j loop1

end:    move $ra,$s1
        jr $ra # 

delay:  move $t1,$a0
        li      $t3,20000
        mult	$t1, $t3			# $t1 *$t3 = Hi and Lo registers
        mflo	$t2					# copy Lo to $t2

        li $v0,resetCoreTimer             #
        syscall                             # resetCoreTimer();

loop:   li $v0,readCoreTimer              # while (1) {
        syscall                             #
        
        blt $v0,$t2,loop                    # while(readCoreTimer() < 200000);
                
        jr $ra #