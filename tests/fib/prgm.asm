.text
main:
    add $t0, $zero, $zero
    lui $s0, 0
    addi $s1, $zero, 1
    ori $v0, $zero, 44

loop:
    sw $s0, 0($t0)

    add $t1, $s0, $s1
    ori $s0, $s1, 0
    addi $s1, $t1, 0

    addi $t0, $t0, 1
    slt $t1, $v0, $t0
    beq $t1, $zero, loop

exit:
    beq $zero, $zero, exit
