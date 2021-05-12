#!/bin/bash

export PATCH="${BATS_TEST_DIRNAME}/diff.patch"
export SECOND_PATCH="${BATS_TEST_DIRNAME}/second.patch"
export ALTERNATIVE_PATCH="${BATS_TEST_DIRNAME}/alternative.patch"
export REVERTED_PATCH="${BATS_TEST_DIRNAME}/reverted.patch"
export UNAPPLICABLE_PATCH="${BATS_TEST_DIRNAME}/unapplicable.patch"
export EXISTING="${BATS_TEST_DIRNAME}/existing.txt"
export RESULT="${BATS_TEST_DIRNAME}/patched.txt"
export ALTERNATIVE_RESULT="${BATS_TEST_DIRNAME}/patched-alternative.txt"
export FILE="${BATS_TMPDIR}/existing.txt"

renamePatchTarget()
{
    local targetFilespec="${1:?}"; shift
    sed -e "s#existing\.txt#$(basename -- "$targetFilespec")#" "$@"
}

tempSetup()
{
    cp -f "$EXISTING" "$FILE"
    cd "$BATS_TMPDIR"
}
setup()
{
    tempSetup
}
