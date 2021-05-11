#!/usr/bin/env bats

load temp

@test "non-applicable patch returns 4" {
    run updateWithPatch "${BATS_TEST_DIRNAME}/unapplicable.patch"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED
$(cat "$EXISTING")" ]
}

@test "non-applicable in-place patch returns 4" {
    run updateWithPatch --in-place "${BATS_TEST_DIRNAME}/unapplicable.patch"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
}
