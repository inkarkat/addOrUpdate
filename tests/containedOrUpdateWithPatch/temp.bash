#!/bin/bash

export XDG_CONFIG_HOME="${BATS_TMPDIR}"

export PATCH="${BATS_TEST_DIRNAME}/diff.patch"
export SECOND_PATCH="${BATS_TEST_DIRNAME}/second.patch"
export ALTERNATIVE_PATCH="${BATS_TEST_DIRNAME}/alternative.patch"
export REVERTED_PATCH="${BATS_TEST_DIRNAME}/reverted.patch"
export UNAPPLICABLE_PATCH="${BATS_TEST_DIRNAME}/unapplicable.patch"
export EXISTING="${BATS_TEST_DIRNAME}/existing.txt"
export RESULT="${BATS_TEST_DIRNAME}/patched.txt"
export FILE="${BATS_TMPDIR}/existing.txt"
export OTHER="${BATS_TMPDIR}/other.txt"

renamePatchTarget()
{
    local targetFilespec="${1:?}"; shift
    sed -e "s#existing\.txt#$(basename -- "$targetFilespec")#" "$@"
}

tempSetup()
{
    rm -rf "${XDG_CONFIG_HOME}/memoizeDecision"
    cp -f "$EXISTING" "$FILE"
    cd "$BATS_TMPDIR"
}
setup()
{
    tempSetup
}
