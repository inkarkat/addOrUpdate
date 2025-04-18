#!/usr/bin/env bats

load temp

@test "error when no BLOCK passed" {
    run -2 addOrUpdateBlock --marker test "$FILE"
    assert_line -n 0 'ERROR: No BLOCK passed; use either -b|--block-text BLOCK-TEXT or -B|--block-file BLOCK-FILE.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no marker passed" {
    run -2 addOrUpdateBlock --block-text $'new\nblock' "$FILE"
    assert_line -n 0 'ERROR: No BEGIN-LINE; use either --begin-marker BEGIN-LINE or -m|--marker WHAT.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no end marker passed" {
    run -2 addOrUpdateBlock --begin-marker START --block-text $'new\nblock' "$FILE"
    assert_line -n 0 'ERROR: No END-LINE; use --end-marker END-LINE.'
    assert_line -n 1 -e '^Usage:'
}

@test "error begin marker is equal to end marker" {
    run -2 addOrUpdateBlock --begin-marker SAME --end-marker SAME --block-text $'new\nblock' "$FILE"
    assert_line -n 0 'ERROR: BEGIN-LINE and END-LINE must be different.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --in-place and --test-only" {
    run -2 addOrUpdateBlock --in-place --test-only --marker test --block-text $'new\nblock' "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --in-place and --test-only.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 addOrUpdateBlock --ignore-nonexisting --create-nonexisting --marker test --block-text $'new\nblock' "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}
