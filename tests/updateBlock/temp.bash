#!/bin/bash

export TEXT='single-line'
export BLOCK="# BEGIN test
$TEXT
# END test"
export CONTENTS="# useless"

export FRESH="${BATS_TEST_DIRNAME}/fresh.txt"
export EXISTING="${BATS_TEST_DIRNAME}/existing.txt"
export ANOTHER="${BATS_TEST_DIRNAME}/another.txt"
export LAST="${BATS_TEST_DIRNAME}/last.txt"
export FILE="${BATS_TMPDIR}/fresh.txt"
export FILE2="${BATS_TMPDIR}/existing.txt"
export FILE3="${BATS_TMPDIR}/another.txt"
export FILE4="${BATS_TMPDIR}/last.txt"
export NONE="${BATS_TMPDIR}/none.txt"
export NONE2="${BATS_TMPDIR}/none2.txt"

tempSetup()
{
    cp -f "$FRESH" "$FILE"
    cp -f "$EXISTING" "$FILE2"
    cp -f "$ANOTHER" "$FILE3"
    cp -f "$LAST" "$FILE4"
    rm -f "$NONE" "$NONE2" 2>/dev/null
}
setup()
{
    tempSetup
}
