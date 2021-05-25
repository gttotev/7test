# NOTE: THIS TEST IS NOT EXHAUSTIVE!
#       YOU SHOULD STILL WRITE YOUR OWN ADDITIONAL TESTS!

# This is a sample assembly program you can use to sanity check
# your CPU. It simply does the following:

# 1. for (int i=0; i < 10; i++)
# 2.     mem[0] += 1
# 3. done: goto done

# A note about line 3:
# Our CPU has no concept of "being done".
# So, we need a graceful way to end our programs.
# One way is to write a branch that just branches to itself.
# The CPU just keeps running that branch at the end of the main logic.

.text

main:
    and $t0, $t0, $zero        # $t0 = 0
    and $t1, $t1, $zero        # $t1 = 10
    addi $t1, $t1, 10

loop:
    beq $t0, $t1, exit         # if ($t0 == 10) exit

    and $t2, $t2, $zero        # $t2 = 0
    lw $t3, 0($t2)             # $t3 = mem[$t2]
    addi $t3, $t3, 1           # $t3 += 1
    sw $t3, 0($t2)             # mem[$t2] = $t3

    addi $t0, $t0, 1           # $t0 += 1
    beq $zero, $zero, loop     # goto loop

exit:
    lw $v0, 0($zero)           # $v0 = mem[0]
    beq $v0, $v0, exit         # goto exit
