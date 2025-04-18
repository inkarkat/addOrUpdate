#!/usr/bin/env bats

load temp

@test "non-applicable patch returns 4" {
    run -4 containedOrUpdateWithPatch "$UNAPPLICABLE_PATCH"
    assert_output ''
}

@test "non-applicable in-place patch returns 4" {
    run -4 containedOrUpdateWithPatch --in-place "$UNAPPLICABLE_PATCH"
    assert_output ''
}
