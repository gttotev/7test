import sys
import pyrtl

import cpu

def parse_line(line: str) -> tuple:
    return tuple(int(n, 16 if n.startswith('0x') else 10) for n in line.split())

def main() -> int:
    """Here is how you can test your code.
    This is very similar to how the autograder will test your code too.

    1. Write a MIPS program. It can do anything as long as it tests the
       instructions you want to test.

    2. Assemble your MIPS program to convert it to machine code. Save
       this machine code to the "i_mem_init.txt" file.
       You do NOT want to use QtSPIM for this because QtSPIM sometimes
       assembles with errors. One assembler you can use is the following:

       https://alanhogan.com/asu/assembler.php

    3. Initialize your i_mem (instruction memory).

    4. Run your simulation for N cycles. Your program may run for an unknown
       number of cycles, so you may want to pick a large number for N so you
       can be sure that the program so that all instructions are executed.

    5. Test the values in the register file and memory to make sure they are
       what you expect them to be.

    6. (Optional) Debug. If your code didn't produce the values you thought
       they should, then you may want to call sim.render_trace() on a small
       number of cycles to see what's wrong. You can also inspect the memory
       and register file after every cycle if you wish.

    Some debugging tips:

        - Make sure your assembly program does what you think it does! You
          might want to run it in a simulator somewhere else (SPIM, etc)
          before debugging your PyRTL code.

        - Make use of the render_trace() functionality. You can use this to
          print all named wires and registers, which is extremely helpful
          for knowing when values are wrong.

        - Test only a few cycles at a time. This way, you don't have a huge
          500 cycle trace to go through!
    """

    if len(sys.argv) != 4:
        print(f'usage: {sys.argv[0]} INSTR_FILE RF_EXPECT_FILE DM_EXPECT_FILE', file=sys.stderr)
        return -1

    # Initialize the i_mem with your instructions.
    with open(sys.argv[1]) as f:
        i_mem_init = {i: int(line, 16) for i, line in enumerate(f)}

    sim_trace = pyrtl.SimulationTrace()
    sim = pyrtl.Simulation(tracer=sim_trace, memory_value_map={cpu.i_mem: i_mem_init})

    # Run for an arbitrarily large number of cycles.
    for cycle in range(len(i_mem_init) * 50):
        sim.step({})

    # Use render_trace() to debug if your code doesn't work.
    # sim_trace.render_trace()

    rf_actual = sim.inspect_mem(cpu.rf)
    with open(sys.argv[2]) as f:
        rf_expect = {addr: val for addr, val in map(parse_line, f)}

    dm_actual = sim.inspect_mem(cpu.d_mem)
    with open(sys.argv[3]) as f:
        dm_expect = {addr: val for addr, val in map(parse_line, f)}

    res = 0

    if rf_actual != rf_expect:
        print('Expected rf:', rf_expect, '\nActual   rf:', rf_actual, file=sys.stderr)
        res = 1

    if dm_actual != dm_expect:
        print('Expected dm:', dm_expect, '\nActual   dm:', dm_actual, file=sys.stderr)
        res = 1

    return res

if __name__ == '__main__':
    sys.exit(main())
