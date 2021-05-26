.text
main:
    lui $t0, 900
    ori $t1, 0xBEEF

    sw $t0, 900($zero)
    sw $t1, 800($zero)

    addi $v0, $zero, 885

    lw $s0, 15($v0)
    lw $s1, -85($v0)

exit:
    beq $zero, $zero, exit
