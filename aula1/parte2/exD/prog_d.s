#int main(void)
# {
#   int value;
#   while(1)
#   {
#       printStr("\nIntroduza um numero (sinal e módulo): ");
#       value = readInt10();
#       printStr("\nValor lido, em base 2: ");
#       printInt(value, 2);
#       printStr("\nValor lido, em base 16: ");
#       printInt(value, 16);
#       printStr("\nValor lido, em base 10 (unsigned): ");
#       printInt(value, 10);
#       printStr("\nValor lido, em base 10 (signed): ");
#       printInt10(value);
#   }
#   return 0;
# } 

    .equ readInt10,5
    .equ printInt,6
    .equ printInt10,7
    .equ printStr,8

    .data

msg1: .asciiz "\nIntroduza um numero (sinal e módulo): "
msg2: .asciiz "\nValor lido, em base 2: "
msg3: .asciiz "\nValor lido, em base 16:  "
msg4: .asciiz "\nValor lido, em base 10 (unsigned): "
msg5: .asciiz "\nValor lido, em base 10 (signed): "

    .text
    .globl main

main:                   # while(1){
    la $a0, msg1        #
    li $v0, printStr    #
    syscall             # printStr("\nIntroduza um numero (sinal e módulo): ");

    li $v0,readInt10    #
    syscall             #
    move $t0,$v0        # value = readInt10(); 

    la $a0, msg2        #
    li $v0, printStr    #
    syscall             # printStr("\nValor lido, em base 2: ");

    move $a0,$t0        # 
    li $a1,2            #
    li $v0,printInt     #
    syscall             # printInt(value, 2); 

    la $a0, msg3        #
    li $v0, printStr    #
    syscall             # printStr("\nValor lido, em base 16:  ");

    move $a0,$t0        # 
    li $a1,16           #
    li $v0,printInt     #
    syscall             # printInt(value, 16); 

    la $a0, msg4        #
    li $v0, printStr    #
    syscall             # printStr("\nValor lido, em base 10 (unsigned): ");

    move $a0,$t0        # 
    li $a1,10           #
    li $v0,printInt     #
    syscall             # printInt(value, 10); 

    la $a0, msg5        #
    li $v0, printStr    #
    syscall             # printStr("\nValor lido, em base 10 (signed): ");

    move $a0,$t0        #
    li $v0,printInt10   #
    syscall             # printInt10(value); 

    j main              #}

    li $v0,0            # return 0;
    jr $ra              # }