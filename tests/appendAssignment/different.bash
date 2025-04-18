#!/bin/bash

load fixture

export INPUT="${BATS_TEST_DIRNAME}/different.txt"
export FILE="${BATS_TMPDIR}/input.txt"
setup()
{
    cp -f "$INPUT" "$FILE"
}
