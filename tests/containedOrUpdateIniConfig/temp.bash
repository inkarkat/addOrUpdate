#!/bin/bash

load fixture

export XDG_CONFIG_HOME="${BATS_TMPDIR}"

export INPUT="${BATS_TEST_DIRNAME}/input.ini"
export MORE2="${BATS_TEST_DIRNAME}/more2.ini"
export MORE3="${BATS_TEST_DIRNAME}/more3.ini"
export FILE="${BATS_TMPDIR}/input.ini"
export FILE2="${BATS_TMPDIR}/more2.ini"
export FILE3="${BATS_TMPDIR}/more3.ini"
export NONE="${BATS_TMPDIR}/none.ini"
export NONE2="${BATS_TMPDIR}/none2.ini"

setup()
{
    cp -f "$INPUT" "$FILE"
    cp -f "$MORE2" "$FILE2"
    cp -f "$MORE3" "$FILE3"
    rm -f "$NONE" "$NONE2" 2>/dev/null
    rm -rf "${XDG_CONFIG_HOME}/memoizeDecision"
}
