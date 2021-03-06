# 7test
Test framework for MIPS CPU from lab07, cs154

## Features
* *AUTOMATIC* assembly of MIPS assembly programs (using MARS)
* *EXCELLENT* selection of crowd-sourced example tests
* *EASY* test definition: all you need is three simple text files!
* *QUICK* turnaround in CPU development and testing cycles
* *EXTENSIBLE* test runner and simulation code: bash and Python code, respectively

## Installation
Clone this repo anywhere you see fit

## Usage
### Basic
```bash
./run_tests.sh LAB07_DIR [test]
```
Where:
* `LAB07_DIR` is the path to the directory containing your `cpu.py`
* `test` is the name of the test to run, from names of `test/` subdirs; omit to run all tests

### Test format
You can easily define your own tests for 7test to execute

Each test lives in its own subdir of `tests/` and can contain:
* `prgm.asm`:   (optional) MIPS assembly program, see 'MARS assembler' section below
* `prgm.hex`:   assembled program, one hex instruction per line
* `rf.exp`:     register file expected values
* `dm.exp`:     data memory expected values

The `*.exp` files are *exhaustive* and have the following format:
```
<ADDR> <VALUE>
...
```
Hex numbers **must** be specified with a leading `0x`, otherwise decimal is assumed

See:
* `tests/` for examples
* `cpu_test.py` for simulation code (including test file parsing)
* `run_tests.sh` for the test runner (bash connoisseurs only ;)

### MARS assembler
If you include a `prgm.asm` file in a test dir, it will be assembled *automatically*
into `prgm.hex` using the bundled MARS assembler when running tests

Making changes to `prgm.asm` later will cause it automatically reassemble, leading to
a drastically shortened testing cyle

*Note*: you will still need to manually fill out `rf.exp` and `dm.exp`

To use MARS to *manually* assemble file `prgm.asm` into `prgm.hex` (as seen in `run_tests.sh`):
```bash
java -jar ./bin/mars.jar a dump .text HexText prgm.hex prgm.asm
```

**DISCLAIMER**: using MARS to auto-assemble *may* result in generated code using `$at` which may
cause tests to fail if not taken into account. Use at your own risk!

## Contributing
It's easy to write your own 7test! And very commendable to contribute it back!

* Fork the GitHub repo and clone it down
* Make a new branch locally, preferably named `test/<testname>`
* Write your new test in `tests/<testname>/`
* Try it out using `run_tests.sh`
* Make a Pull Request to the GitHub repo from your branch (and fork)
