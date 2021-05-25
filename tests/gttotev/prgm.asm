.text
main:
    lui $v0, 0xDEAD
    ori $v0, $v0, 0xBEEF

    addi $v1, $v0, 1
    addi $13, $v0, -1

    add $30, $zero, $v0
    add $31, $v0, $zero

    add $29, $v1, $13
    add $28, $13, $v1

    slt $18, $v1, $v0
    slt $19, $v0, $v1
    beq $18, $19, exit

    sw $v0, 0($v0)
    lw $20, 0($v0)
    lw $zero, 0($v0)

    and $24, $v0, $13
    beq $24, $13, exit

    #
    lui $v0, 0xABBA
    #

exit:
    beq $zero, $zero, exit
