import sys
import difflib

import pyrtl

import cpu

def parse_line(line: str) -> tuple:
    return tuple(int(n, 16 if n.startswith('0x') else 10) for n in line.split())

def diff_dict(d: dict) -> list:
    return [f'| {k:<10} {v:<10} ; {k:#010x} {v:#010x} |\n' for k, v in sorted(d.items())]

def err_cmp(expect: dict, actual: dict, msg: str) -> int:
    if expect == actual:
        return 0

    sys.stderr.writelines(difflib.unified_diff(diff_dict(expect), diff_dict(actual), f'{msg} expected', f'{msg} actual'))
    sys.stderr.write('\n')
    return 1

def main() -> int:
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
    res |= err_cmp(rf_expect, rf_actual, 'rf')
    res |= err_cmp(dm_expect, dm_actual, 'd_mem')

    return res

if __name__ == '__main__':
    sys.exit(main())
