#!/usr/bin/env bats

load temp

@test "error when no block passed" {
    run -2 containedOrAddOrUpdateBlock "$FILE"
    assert_line -n 0 'ERROR: No BLOCK passed; use either -b|--block-text BLOCK-TEXT or -B|--block-file BLOCK-FILE.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 containedOrAddOrUpdateBlock --ignore-nonexisting --create-nonexisting --marker test --block-text new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}
