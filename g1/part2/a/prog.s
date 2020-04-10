        .equ printStr,8
        .equ putChar,3
        .equ getChar,2

        .data
        .text
        .globl main

main:   li      $v0,getChar	    # getChar()
		syscall
        move    $t0,$v0         # c = getChar()

        beq	    $t0,'\n',end    # if(c != '\   n')

        move    $a0,$t0
		li	    $v0,putChar	 # putChar(c)
		syscall

        j       main

end:    li      $v0,0 # return 0;
        jr      $ra
