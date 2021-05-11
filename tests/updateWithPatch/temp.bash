#!/bin/bash

export PATCH="${BATS_TEST_DIRNAME}/diff.patch"
export REVERTED_PATCH="${BATS_TEST_DIRNAME}/reverted.patch"
export EXISTING="${BATS_TEST_DIRNAME}/existing.txt"
export RESULT="${BATS_TEST_DIRNAME}/patched.txt"
export FILE="${BATS_TMPDIR}/existing.txt"

setup()
{
    cp -f "$EXISTING" "$FILE"
    cd "$BATS_TMPDIR"
}
