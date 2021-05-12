#!/usr/bin/env bats

load temp

@test "non-applicable patch returns 4" {
    run containedOrUpdateWithPatch "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "" ]
}

@test "non-applicable in-place patch returns 4" {
    run containedOrUpdateWithPatch --in-place "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "" ]
}
