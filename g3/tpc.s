          .equ SFR_BASE_HI, 0xBF88 # 16 MSbits of SFR area

          .equ TRISB, 0x6040 	# TRISB address is 0xBF886040
          .equ PORTB, 0x6050	# PORTB address is 0xBF886050
          .equ LATB, 0x6060 	# LATB  address is 0xBF886060
          .equ ODCB, 0x6070 	# ODCB  address is 0xBF886070

          .equ TRISE, 0x6100 	# TRISE address is 0xBF886100
          .equ PORTE, 0x6110	# PORTE address is 0xBF886110
          .equ LATE, 0x6120 	# LATE  address is 0xBF886120
          .equ ODCE, 0x6130 	# ODCE  address is 0xBF886130

          .data

          .text
          .globl main

main: li $v0,5    # syscall readInt10()
      syscall
      beq $v0,1,exerc_1_2_3
      beq $v0,4,exerc_4
      j   main

exerc_1_2_3:  lui $t0, SFR_BASE_HI
                                 # Configures RB ports as inputs
          lw $t1, TRISB($t0)     # $t1 <- TRISB
          andi $t1, $t1, 0xFFF0  # $t1 <- $t1 & 0xFFF0
          ori  $t1, $t1, 0x000F  # $t1 <- $t1 | 0x000F
          sw $t1, TRISB($t0)     # TRISB <- $t1

                                 # Configures RE ports as outputs
          lw $t2, TRISE($t0)     # $t2 <- TRISE
          andi $t2, $t2, 0xFFF0  # $t2 <- $t2 & 0xFFF0
          sw $t2, TRISE($t0)     # TRISE <- $t2

while1:                           # while (1) {
                                 #   Read from RB ports
          lw $t3, PORTB($t0)
          andi $t3, $t3, 0x000F

                                 #   Write to RE ports
          lw $t4, LATE($t0)      #     Read
          andi $t4, $t4, 0xFFF0  #     Modify
          or $t4, $t3, $t4

          sw $t4, LATE($t0)      #     Write

          j while1                # }

          li $v0, 1
          jr $ra

exerc_4:                             # void main(void) {

          subu $sp, $sp, 20	      #  
          sw $ra, 0($sp)          #
          sw $s0, 4($sp)          #
          sw $s1, 8($sp)          #
          sw $s2, 12($sp)         #
          sw $s3, 16($sp)         #

          li $s0, 0               #    int v = 0;

                                  #    TRISE0 = 0; // Configura o porto RE0 como saída
          lui $s1, SFR_BASE_HI    #
          lw $s2, TRISE($s1)      #       $s2 <- TRISE
          andi $s2, $s2, 0xFFFE   #       $s2 <- $s2 & 0xFFFE (cleans bit 0, ie bit 0 = 0)
          sw $s2, TRISE($s1)      #       TRISE <- $s2

while4:                            #    while(1) {
                                  #       LATE0 = v; // Escreve v no bit 0 do porto E
          lw $s3, LATE($s1)       #          $s3 <- LATE
          andi $s3, $s3, 0xFFFE   #          $s3 <- $s3 & 0xFFFE (cleans bit 0, ie bit 0 = 0)
          or $s3, $s3, $s0        #          $s3 <- $s3 | $s0
          sw $s3, LATE($s1)       #          LATE <- $s3

          li $a0, 500             #       delay(500); // Atraso de 500ms
          jal delay

          xori $s0, $s0, 1        #       v ^= 1; // complementa o bit 0 de v (v = v xor 1)

          j while4                 #    }

         lw $ra, 0($sp)          #    Restore $ra, $s registers
          lw $s0, 4($sp)          #
          lw $s1, 8($sp)          #
          lw $s2, 12($sp)         #
          lw $s3, 16($sp)         #
          addiu $sp, $sp, 20      #

          li $v0, 1
          jr $ra                  # }