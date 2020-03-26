            .equ SFR_BASE_HI, 0xBF88 # 16 MSbits of SFR area

            .equ TRISB, 0x6040 	# TRISB address is 0xBF886040
            .equ PORTB, 0x6050	# PORTB address is 0xBF886050
            .equ LATB, 0x6060 	# LATB  address is 0xBF886060
            .equ ODCB, 0x6070 	# ODCB  address is 0xBF886070

            .equ TRISE, 0x6100 	# TRISE address is 0xBF886100
            .equ PORTE, 0x6110	# PORTE address is 0xBF886110
            .equ LATE, 0x6120 	# LATE  address is 0xBF886120
            .equ ODCE, 0x6130 	# ODCE  address is 0xBF886130

            .equ READ_CORE_TIMER,11
            .equ RESET_CORE_TIMER,12

            .data
msg1:       .asciiz "\nQual o Exercício a realizar?\n(1,2,3,4. 5 Termina o Programa)\n"
msg2:       .asciiz "\nDurante o loop se pressionar x, o programa retorna ao menu"
            .text
            .globl main

main:       move $s0,$ra

subMain:    #lw $a0,msg1
            #li $v0,8
            #syscall                #mensagem menu

            li $v0,5    # syscall readInt10()
            syscall
            beq $v0,1,ex1
            beq $v0,2,ex2
            beq $v0,3,ex3
            beq $v0,4,ex4
            beq $v0,5,end
            j   subMain

ex1:        #lw $a0,msg2
            #li $v0,8
            #syscall                #mensagem sobre a interrupção do loop

            lui $t0, SFR_BASE_HI
                                   # Mete RB como input (ler switches)
            lb $t1, TRISB($t0)     # $t1 <- TRISB
            andi $t1, $t1, 0xFFF0  # $t1 <- $t1 & 0xFFF0
            ori  $t1, $t1, 0x000F  # $t1 <- $t1 | 0x000F
            sw $t1, TRISB($t0)     # TRISB <- $t1

                                   # Mete RE como outputs (para os leds)
            lw $t2, TRISE($t0)     # $t2 <- TRISE
            andi $t2, $t2, 0xFFF0  # $t2 <- $t2 & 0xFFF0
            sw $t2, TRISE($t0)     # TRISE <- $t2

loop1:      li $v0,1               # while (1)        
            syscall
            beq $v0,'x',endloop1                  
                                   #   Lê RB0
            lw $t3, PORTB($t0)
            andi $t3, $t3, 0xFFFF

                                    #  Escreve RE0
            lw $t4, LATE($t0)       #  Lê
            andi $t4, $t4, 0x000   #  Modifica
            or $t4, $t3, $t4

            sw $t4, LATE($t0)       # Escreve

            j loop1                # }
endloop1:   j subMain

ex2:        #lw $a0,msg2
            #li $v0,8
            #syscall                #mensagem sobre a interrupção do loop

            lui $t0, SFR_BASE_HI
                                   # Mete RB como input (ler switches)
            lb $t1, TRISB($t0)     # $t1 <- TRISB
            andi $t1, $t1, 0xFFF0  # $t1 <- $t1 & 0xFFF0
            ori  $t1, $t1, 0x000F  # $t1 <- $t1 | 0x000F
            sw $t1, TRISB($t0)     # TRISB <- $t1

                                   # Mete RE como outputs (para os leds)
            lw $t2, TRISE($t0)     # $t2 <- TRISE
            andi $t2, $t2, 0xFFF0  # $t2 <- $t2 & 0xFFF0
            sw $t2, TRISE($t0)     # TRISE <- $t2

loop2:      li $v0,1               # while (1)        
            syscall
            beq $v0,'x',endloop2                
                                   #   Lê RB0
            lw $t3, PORTB($t0)
            andi $t3, $t3, 0xFFFF

                                    #  Escreve RE0
            lw $t4, LATE($t0)       #  Lê
            ori $t4, $t4, 0x0001    #  Modifica
            xor $t4, $t3, $t4

            sw $t4, LATE($t0)       # Escreve

            j loop2                # }
endloop2:   j subMain

ex3:        #lw $a0,msg2
            #li $v0,8
            #syscall                #mensagem sobre a interrupção do loop

            lui $t0, SFR_BASE_HI
                                   # Mete RB como input (ler switches)
            lb $t1, TRISB($t0)     # $t1 <- TRISB
            andi $t1, $t1, 0xFFF0  # $t1 <- $t1 & 0xFFF0
            ori  $t1, $t1, 0x000F  # $t1 <- $t1 | 0x000F
            sw $t1, TRISB($t0)     # TRISB <- $t1

                                   # Mete RE como outputs (para os leds)
            lw $t2, TRISE($t0)     # $t2 <- TRISE
            andi $t2, $t2, 0xFFF0  # $t2 <- $t2 & 0xFFF0
            sw $t2, TRISE($t0)     # TRISE <- $t2

loop3:      li $v0,1               # while (1)        
            syscall
            beq $v0,'x',endloop3                
                                   #   Lê RB0,RB1,RB2,RB3
            lw $t3, PORTB($t0)
            xori $t3, $t3, 0x0009

                                    #  Escreve RE0,RE1,RE2,RE3
            lw $t4, LATE($t0)       #  Lê
            andi $t4, $t4, 0xFFF0   #  Modifica
            or $t4, $t3, $t4

            sw $t4, LATE($t0)       # Escreve

            j loop3                # }
endloop3:   j subMain


ex4:      #lw $a0,msg2
          #li $v0,8
          #syscall                 #mensagem sobre a interrupção do loop
                                  # void main(void) {
          li $t0, 0               #    int v = 0;

                                  #    TRISE0 = 0; // Configura o porto RE0 como saída
          lui $t1, SFR_BASE_HI    #
          lw $t2, TRISE($t1)      #       $s2 <- TRISE
          andi $t2, $t2, 0xFFFE   #       $s2 <- $s2 & 0xFFFE (cleans bit 0, ie bit 0 = 0)
          sw $t2, TRISE($t1)      #       TRISE <- $s2

loop4:    li $v0,1                    
          syscall
          beq $v0,'x',endloop4                        
                                  #          while(1) {
                                  #          LATE0 = v; // Escreve v no bit 0 do porto E
          lw $t3, LATE($t1)       #          $t3 <- LATE
          andi $t3, $t3, 0xFFFE   #          $t3 <- $t3 & 0xFFFE (limpa bit 0, ie bit 0 = 0)
          or $t3, $t3, $t0        #          $t3 <- $t3 | $t0
          sw $t3, LATE($t1)       #          LATE <- $t3

          li $v0,RESET_CORE_TIMER             #resetCoreTimer();
          syscall

delay:    li $v0,1                    
          syscall
          beq $v0,'x',endloop4

          li $v0,READ_CORE_TIMER              # while (1) {
          syscall                             #

          bne $v0,10000000,delay                # while(readCoreTimer() < 200000);

          xori $t0, $t0, 1        #       v ^= 1; // complementa o bit 0 de v (v = v xor 1)

          j loop4                 #    }
endloop4: j subMain

end:        move $ra,$s0
            li $v0, 1
            jr $ra                          #termina o programa
