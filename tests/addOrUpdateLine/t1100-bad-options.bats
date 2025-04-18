#!/usr/bin/env bats

load temp

@test "error when no LINE passed" {
    run -2 addOrUpdateLine "$FILE"
    assert_line -n 0 'ERROR: No LINE passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --in-place and --test-only" {
    run -2 addOrUpdateLine --in-place --test-only --line new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --in-place and --test-only.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 addOrUpdateLine --ignore-nonexisting --create-nonexisting --line new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --add-before and --add-after" {
    run -2 addOrUpdateLine --add-before 4 --add-after 6 --line new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --add-before and --add-after.'
    assert_line -n 1 -e '^Usage:'
}
