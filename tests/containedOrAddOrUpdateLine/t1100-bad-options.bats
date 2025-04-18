#!/usr/bin/env bats

load temp

@test "error when no LINE passed" {
    run -2 containedOrAddOrUpdateLine "$FILE"
    assert_line -n 0 'ERROR: No LINE passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 containedOrAddOrUpdateLine --ignore-nonexisting --create-nonexisting --line new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}
