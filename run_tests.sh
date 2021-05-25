#!/bin/bash
if [ -z "$1" ]; then
    echo "usage: $0 LAB07_DIR [test]"
    exit -1
fi

export PYTHONPATH="$(realpath $1)"
WD="$(dirname $(realpath $BASH_SOURCE))"
res=0

for t in ${2:-$(ls tests)}; do
    cd "$WD/tests/$t"
    if [ ! -f prgm.asm -a ! -f prgm.hex ] || [ ! -f rf.exp ] || [ ! -f dm.exp ]; then
        echo "[$t] SKIPPED: missing required files prgm.(hex|asm), rf.exp, dm.exp"
        echo
        continue
    fi

    if [ prgm.asm -nt prgm.hex ]; then
        echo [$t] Assembling using MARS...
        java -jar "$WD/bin/mars.jar" a dump .text HexText prgm.hex prgm.asm
        if [ prgm.asm -nt prgm.hex ]; then
            echo [$t] SKIPPED: assembly using MARS failed
            echo
            continue
        fi
    fi
    if ! "$WD/cpu_test.py" prgm.hex rf.exp dm.exp; then
        echo [$t] FAILED!
        echo
        res=1
    fi
done

[ $res -eq 0 ] && echo "===== All tests PASSED! :) ====="
exit $res
