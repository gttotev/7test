#!/bin/bash
if [ -z "$1" ]; then
    echo "usage: $0 LAB07_DIR [test]"
    exit -1
fi

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

export PYTHONPATH="$(realpath $1)"
WD="$(dirname $(realpath $BASH_SOURCE))"
TMP_OUT=$(mktemp)
res=0

echo "======= Welcome to 7test! ======="
echo

for t in ${2:-$(ls "$WD/tests")}; do
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

    python "$WD/cpu_test.py" prgm.hex rf.exp dm.exp &> $TMP_OUT
    if [ $? -ne 0 ]; then
        echo [$t] FAILED!
        echo "================================="
        cat $TMP_OUT
        echo "================================="
        res=1
    else
        echo [$t] PASSED
    fi
    echo
done

[ $res -eq 0 ] && echo "===== All tests PASSED! :)  =====" || echo "===== Some tests FAILED! :( ====="
exit $res
