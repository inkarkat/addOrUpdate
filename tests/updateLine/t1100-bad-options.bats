#!/usr/bin/env bats

load temp

@test "error when no PATTERN passed" {
    run -2 updateLine --replacement new "$FILE"
    assert_line -n 0 'ERROR: No --update-match PATTERN passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no --line and no --replacement is passed" {
    run -2 updateLine --update-match old "$FILE"
    assert_line -n 0 'ERROR: No --line LINE or --replacement REPLACEMENT passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --in-place and --test-only" {
    run -2 updateLine --in-place --test-only --update-match old --replacement new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --in-place and --test-only.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 updateLine --ignore-nonexisting --create-nonexisting --update-match old --replacement new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --add-before and --add-after" {
    run -2 updateLine --add-before 4 --add-after 6 --update-match old --replacement new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --add-before and --add-after.'
    assert_line -n 1 -e '^Usage:'
}

@test "error on --create-nonexisting" {
    run -2 updateLine --create-nonexisting --update-match old --replacement new "$FILE"
    assert_line -n 0 'ERROR: Cannot use --create-nonexisting when appending is not allowed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no --update-match is passed" {
    run -2 updateLine --replacement new "$FILE"
    assert_line -n 0 'ERROR: No --update-match PATTERN passed.'
    assert_line -n 1 -e '^Usage:'
}
