#!/bin/bash

export SUBDIR="${BATS_TMPDIR}/subdir/existing.txt"

subdirPatchTarget()
{
    sed -e 's#original\.txt#subdir/&#' -e 's#existing\.txt#subdir/&#' "$@"
}

setup()
{
    tempSetup
    mkdir -p "${BATS_TMPDIR}/subdir"
}

teardown()
{
    rm -rf "${BATS_TMPDIR:?}/subdir"
}
