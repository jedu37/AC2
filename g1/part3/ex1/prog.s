#Var Map
#$t0 = s
#$t1 = cnt
#$t2 = c
#$t3 = i
#$t4 = t

		.equ     printInt,6
		.equ	 putChar,3
		.equ	 inkey,1

		.data
		.text
		.globl main
		
main:	move   $s0,$ra
		li	   $t0,0 		 # s = 0;
		li     $t1,0 		 # cnt = 0;
		li     $t5,0		 # stopC = 0;
		
loop:	li 	   $a0,'\r'
		li	   $v0,putChar	 # putChar('\r')
		syscall
		
		move   $a0,$t1
		li	   $a1,0x0003000A
		li	   $v0,printInt  # printInt( cnt, 10 | 3 << 16 );
		syscall
		
		li 	   $a0,'\t'
		li	   $v0,putChar	 # putChar('\t')
		syscall
		
		move   $a0,$t1
		li	   $a1,0x00080002
		li	   $v0,printInt  # printInt( cnt, 2 | 8 << 16 );
		syscall
		
		li     $a0,5
		jal	   wait
		
		li	   $v0,inkey
		syscall
		move   $t2,$v0       # c = inkey();
		
		
if1:    bne	   $t2,'+',if2   # if( c == '+' )
		li	   $t0,0         # s = 0;
		j	   if5

if2:    bne	   $t2,'-',if3   # if( c == '-' )
		li	   $t0,1         # s = 1;
		j	   if5
		
if3:    bne	   $t2,'s',if4   # if( c == 's' )
		not	   $t5,$t5     # stopC = not stopC;
		j	   if5
		
if4:    bne	   $t2,'r',if6   # if( c == 'r' )
		li	   $t1,0

if6:    bne	   $t2,'x',if5   # if( c == 'q' )
        j      end    

if5:    bne   $t5,0,while  # Se o stop estiver ativo salta add/sub do counter  

        bne	   $t0,0,else   # if( s == 0 )
		add    $t1,$t1,1    # cnt + 1
		and    $t1,$t1,0xFF # cnt = (cnt + 1) & 0xFF;
		
		j	   while

else:   bne	   $t0,1,else   # else if( s == 1 )
		sub    $t1,$t1,1    # cnt - 1
		and    $t1,$t1,0xFF # cnt = (cnt - 1) & 0xFF;

while: 	j 	   loop 
end:    la     $a0,msg
		li     $v0,8
		syscall

		move   $ra,$s0
		li     $v0,0         # return 0;       
        jr     $ra
        
        .globl wait
        
wait:	li     $t3,0         # i = 0;
        mul	   $t4,$a0,515000# i*515000
  
for :   beq    $t3,$t4,endF  # i < 515000 * ts
        add    $t3,1         # i++;
        j	   for
   
endF:   j	   $ra
