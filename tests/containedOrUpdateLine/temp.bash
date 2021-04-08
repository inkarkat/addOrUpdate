#!/bin/bash

export XDG_CONFIG_HOME="${BATS_TMPDIR}"

export INPUT="${BATS_TEST_DIRNAME}/input.txt"
export FILE="${BATS_TMPDIR}/input.txt"
init()
{
    cp -f "$INPUT" "$FILE"
    rm -rf "${XDG_CONFIG_HOME}/memoizeDecision"
}
