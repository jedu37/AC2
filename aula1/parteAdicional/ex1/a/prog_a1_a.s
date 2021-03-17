# void wait(int);
# int main(void)
# {
#   int s = 0;
#   int cnt = 0;
#   char c;
#   do
#   {
#       putChar('\r'); // Carriage return character
#       printInt( cnt, 10 | 3 << 16 ); // 0x0003000A: decimal w/ 3 digits
#       putChar('\t'); // Tab character
#       printInt( cnt, 2 | 8 << 16 ); // 0x00080002: binary w/ 8 bits
#       wait(5);
#       c = inkey();
#       if( c == '+' )
#           s = 0;
#       if( c == '-' )
#           s = 1;
#       if( s == 0 )
#           cnt = (cnt + 1) & 0xFF;
#       else
#           cnt = (cnt - 1) & 0xFF;
#   } while( c != 'q' );
#   return 0;
# }
# void wait(int ts)
# {
#   int i;
#   for( i=0; i < 515000 * ts; i++ );
# }

# Mapa de registos
# s -> $s0
# cnt -> $s1
# c -> $s2

    .equ putChar,3
    .equ printInt,6
    .equ inkey,1

    .data

    .text
    .globl main

main:   addiu $sp,$sp,-16         # Guardar Registos na Stack
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp) 			 
        sw $ra, 12($sp)

        li $s0,0                  # int s = 0
        li $s1,0                  # int cnt = 0

do:                               # do{     
        li $a0, '\r'            #     
        li $v0,putChar            #
        syscall                   #     putChar('\r'); // Carriage return character

        move $a0,$s1              #
        li $a1,0x0003000A         #
        li $v0,printInt           #
        syscall                   #     printInt( cnt, 10 | 3 << 16 ); // 0x0003000A: decimal w/ 3 digits 

        li $a0, '\t'                #     
        li $v0,putChar            #
        syscall                   #     putChar('\t'); // Tab character

        move $a0,$s1              #
        li $a1,0x00080002         #
        li $v0,printInt           #
        syscall                   #     printInt( cnt, 2 | 8 << 16 ); // 0x00080002: binary w/ 8 bits 

        li $a0,5                  #
        jal wait                  #     wait(5);

        li $v0,inkey              #
        syscall                   #
        move $s2,$v0              #     c = inkey(); 

if_c:   bne $s2,'+',else_c        #     if( c == '+' )
        li $s0,0                  #         s = 0; 
        j skip

else_c: bne $s2,'-',skip          #     if( c == '-' )
        li $s0,1                  #         s = 1; 

skip:

if_s:  bnez $s0,else_s            #    if( s == 0 ) 
       addi $s1,$s1,1             #         cnt = cnt + 1;
       andi $s1,$s1,0XFF          #         cnt = cnt & 0xFF; 
       j while                    #

else_s: bne $s0,1,while
        addi $s1,$s1,-1            #         cnt = cnt - 1;
        andi $s1,$s1,0XFF          #         cnt = cnt & 0xFF; 

while: bne $s2,'q',do             # } while( c != 'q' ); 

        
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp) 			 
        lw $ra, 12($sp)
        addiu $sp,$sp,16          # Restaurar os Registos da Stack

        li $v0,0                  # return 0;
        jr $ra                    # }

# Mapa de registos - Wait
# i -> $t0
# 515000 * ts -> $t1
wait:                             # void wait(int ts){
        li $t0,0                  # int i = 0
        li $t1,515000             # $t2 = 515000
        mul $t1,$t1,$a0           # $t2 = 515000 * ts

for_w:                            # for(
        beq $t0,$t1,end_w         #     i < 515000 * ts;
        addi $t0,$t0,1            #     i++;
        j for_w                   #);

end_w: jr $ra                     #}