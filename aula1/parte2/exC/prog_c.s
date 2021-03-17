# int main(void)
# {
#  char c;
#  do
#  {
#       while( (c = inkey()) == 0 );
#       if( c != '\n' )
#           putChar( c );
#   } while( c != '\n' );
#   return 0;
# } 

    .equ inKey,1
    .equ putChar,3

    .data
    .text
    .globl main

main:                       # do{

    li $v0,inKey            #
    syscall                 #
    move $t0,$v0            #   c = inKey(); 

    beq $t0,0,main          #   while(c == 0);
    
    beq $t0,'\n',skip       #   if( c != '\n' ) 

    move $a0,$t0            #
    li $v0,putChar          #
    syscall                 #       putChar(c); 

skip:

    bne $t0,'\n',main       # }while( c != '\n');

    li $v0,0                # return 0;
    jr $ra                  #}