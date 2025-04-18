#!/bin/bash

export INPUT="${BATS_TEST_DIRNAME}/input.txt"
export FILE="${BATS_TMPDIR}/input.txt"

setup()
{
    cp -f "$INPUT" "$FILE"
}
