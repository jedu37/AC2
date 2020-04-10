        .equ printStr,8
        .equ putChar,3
        .equ inKey,1

        .data
        .text
        .globl main

main:   li      $v0,inKey	    # inKey()
		syscall
        move    $t0,$v0         # c = inKey()

        beq     $t0,'',main     #while((c=inkey())==0)
        beq	    $t0,'\n',end    # if(c != '\   n')

        move    $a0,$t0
		li	    $v0,putChar	 # putChar(c)
		syscall

        j       main

end:    li      $v0,0 # return 0;
        jr      $ra