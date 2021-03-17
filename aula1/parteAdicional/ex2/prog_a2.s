    .equ STR_MAX_SIZE,20
    .equ printStr,8
    .equ readStr,9
    .equ printInt,6
    .equ printInt10,7


    .data

msg1: .asciiz "Introduza 2 strings: "
    .align 2

msg2: .asciiz "Resultados:\n"
    .align 2

str1: .space 21
    .align 2

str2: .space 21
    .align 2

str3: .space 41
    .align 2

    .text
    .globl main

main:   addiu $sp,$sp,-4    # Guardar registos na Stack
        sw $ra,0($sp)   #
                            # int main(void)

        la $a0, msg1        #
        li $v0, printStr    # 
        syscall             # printStr("Introduza 2 strings: "); 

        la $a0,str1         #
        li $a1,STR_MAX_SIZE #
        li $v0,readStr      #
        syscall             # readStr( str1, STR_MAX_SIZE );

        la $a0,str2         #
        li $a1,STR_MAX_SIZE #
        li $v0,readStr      #
        syscall             # readStr( str2, STR_MAX_SIZE );

        la $a0, msg2        #
        li $v0, printStr    # 
        syscall             # printStr("Resultados:\n");

        la $a0, str1        #
        jal strlen          #
        move $a0,$v0        #
        li $a1,10           #
        li $v0,printInt     #
        syscall             # prinInt( strlen(str1), 10 );

        la $a0, str2        #
        jal strlen          #
        move $a0,$v0        #
        li $a1,10           #
        li $v0,printInt     #
        syscall             # prinInt( strlen(str2), 10 );

        la $a0,str3         #
        la $a1,str1         #
        jal strcpy          # strcpy(str3, str1);

        la $a0,str3         #
        la $a1,str2         #
        jal strcat          #
        la $a0, str3        #
        li $v0, printStr    # 
        syscall             # printStr(strcat(str3, str2));

        la $a0,str1         #
        la $a1,str2         #
        jal strcmp          #
        move $a0,$v0        #
        li $v0,printInt10   #
        syscall             # printInt10( strcmp(str1, str2) );

        lw $ra,0($sp)   #
        addiu $sp,$sp, 4    # Restaurar registos da Stack
        li $v0,0            # return 0;
        jr $ra              #}

# Mapa de Registos
# len -> $t0
# *s -> $t1

strlen:                       #int strlen(char *s){
         li $t0,0             # for (int len = 0;
for_sl:  lb $t1,0($a0)        #      $t1 = *s;
         beq $t1,'\0', end_sl #      *s != '\0';
         addi $t0,$t0,1       #      len++;
         addiu $a0,$a0,1      #       s++);
         j for_sl             #

end_sl:  move $v0,$t0         # return len;
         jr $ra               #}

# Mapa de Registos
# *p -> $t0
strcpy:                       # char *strcpy(char *dst, char *src){
        move $t0,$a0          #     char *p = dst;
for_sc: lb $t1,0($a1)         #     $t1 = *src;
        beq $t1,'\0', end_sc  #     $t1 != '\0';
        sb $t1,0($a0)         #     *dst = *src;
        addiu $a0,$a0,1       #     dst ++;
        addiu $a1,$a1,1       #     src ++;
        j for_sc              #

end_sc: move $v0,$t0          # return p;
        jr $ra                #}

# Mapa de Registos
# *p -> $s0

strcat:                       # char *strcat(char *dst, char *src){
        addiu $sp,$sp,-8      # Guardar registos na Stack
        sw $s0,0($sp)     #
        sw $ra,4($sp)     #
        move $s0,$a0          #     char *p = dst;
for_ca: lb $t0,0($a0)         # for( 
        beq $t0,'\0',end_ca   #     *dst != '\0';
        addiu $a0,$a0,1       #     dst++ 
        j for_ca              #);

end_ca: move $a0,$a0          #
        move $a1,$a1          #
        jal strcpy            # strcpy( dst, src ); 

        lw $s0,0($sp)     #
        lw $ra,4($sp)     #
        addiu $sp,$sp,8       # Restaurar registos da Stack
        move $v0,$s0          # return p;
        jr $ra                # }

# Mapa de Registos
strcmp:                       # int strcmp(char *s1, char *s2){
for_cp: lb $t0,0($a0)         # $t0 = *s1      
        lb $t1,0($a1)         # $t1 = *s2
        bne $t0,$t1,end_cp    # for( (*s1 == *s2)  &&
        beq $t0,'\0',end_cp   #       (*s1 != '\0');
        addiu $a0,$a0,1       #       s1++;
        addiu $a1,$a1,1       #       s2++;
        j for_cp              #);
end_cp: sub $v0,$t0,$t1       # return( *s1 - *s2 );
        jr $ra                # }
