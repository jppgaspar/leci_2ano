# (1/frequency)*1000=miliseconds
# (1/1)*1000=miliseconds
# 1000miliseconds
#

        .equ READ_CORE_TIMER,11
        .equ RESET_CORE_TIMER,12
        .equ ADDR_BASE_HI,0xBF88
        .equ TRISE,0x6100
        .equ PORTE,0x6110
        .equ LATE,0x6120
        .equ TRISB,0x6040
        .equ PORTB,0x6050
        .equ LATB,0x6060
        .data
        .text
        .globl main

main:   li $t0,0                # cnt = 0

        lui $t1,ADDR_BASE_HI
        lw $t2,TRISE($t1)       # obter configuracao de bits
        andi $t2,$t2,0xFFF0     # 1111 1111 1111 0000 -> RE0 a RE3 a 0, ou seja, saídas
        sw $t2,TRISE($t1)       # guardar configuracao

        lw $t2,TRISB($t1)       # obter configuracao de bits
        andi $t2,$t2,0xFFF0     # (reset)
        ori $t2,$t2,0x000F      # 0000 0000 0000 1111 -> RB0 a RE3 a 1, ou seja, entradas
        sw $t2,TRISB($t1)       # guardar configuracao

while:  lw $t3,LATE($t1)        # obter configuracao de bits
        andi $t3,$t3,0xFFF0     # (reset)
        or $t3,$t3,$t0          # LATE0(RE0) = cnt
        sw $t3,LATE($t1)        # guardar configuracao

        addiu $sp,$sp,-4        #
        sw $ra,0($sp)           #
        li $a0,1000             # $a0 = 1000
        jal delay               # delay($a0)
        lw $ra,0($sp)           #
        addiu $sp,$sp,4         #

if:     blt $t0,15,else         # if($t0<15) salta para else
        li $t0,0                # cnt = 0
        j endif                 

else:   addi $t0,$t0,1          # cnt++

endif:  j while

        li $v0,0
        jr $ra

#

delay:  li $v0,12
        syscall

whiled: li $v0,11
        syscall
        mul $a0,$a0,20000
        ble $v0,$a0,whiled
        jr $ra
