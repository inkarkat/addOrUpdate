#!/usr/bin/env bats

load temp

@test "error when no PATCH passed" {
    run -2 containedOrUpdateWithPatch
    assert_line -n 0 'ERROR: No PATCH passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --first and --all" {
    run -2 containedOrUpdateWithPatch --first --all "$PATCH"
    assert_line -n 0 'ERROR: Cannot combine --first and --all.'
    assert_line -n 1 -e '^Usage:'
}
