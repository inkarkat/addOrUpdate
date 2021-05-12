#!/usr/bin/env bats

load temp

@test "non-applicable patch returns 4" {
    run updateWithPatch "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED
$(cat "$EXISTING")" ]
}

@test "non-applicable in-place patch returns 4" {
    run updateWithPatch --in-place "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
}
