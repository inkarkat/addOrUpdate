#!/bin/bash

load fixture

export XDG_CONFIG_HOME="${BATS_TMPDIR}"

export INPUT="${BATS_TEST_DIRNAME}/input.txt"
export MORE2="${BATS_TEST_DIRNAME}/more2.txt"
export MORE3="${BATS_TEST_DIRNAME}/more3.txt"
export FILE="${BATS_TMPDIR}/input.txt"
export FILE2="${BATS_TMPDIR}/more2.txt"
export FILE3="${BATS_TMPDIR}/more3.txt"
export NONE="${BATS_TMPDIR}/none.txt"
export NONE2="${BATS_TMPDIR}/none2.txt"

setup()
{
    cp -f "$INPUT" "$FILE"
    cp -f "$MORE2" "$FILE2"
    cp -f "$MORE3" "$FILE3"
    rm -f "$NONE" "$NONE2" 2>/dev/null
    rm -rf "${XDG_CONFIG_HOME}/memoizeDecision"
}
