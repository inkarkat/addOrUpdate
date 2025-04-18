#!/usr/bin/env bats

load temp

@test "test-only update with nonexisting marker returns 1" {
    run -1 updateBlock --test-only --marker test --block-text "single-line" "$FILE"
    assert_output ''
    diff -y "$FILE" "$FRESH"
}

@test "test-only update with nonexisting marker and multi-line block returns 1" {
    run -1 updateBlock --test-only --marker test --block-text $'across\nmultiple\nlines' "$FILE"
    assert_output ''
    diff -y "$FILE" "$FRESH"
}

@test "test-only update with existing marker and same single-line block returns 99" {
    run -99 updateBlock --test-only --marker subsequent --block-text "Single line" "$FILE2"
    assert_output ''
    diff -y "$FILE2" "$EXISTING"
}

@test "test-only update with existing marker and different single-line block succeeds" {
    run -0 updateBlock --test-only --marker subsequent --block-text "Changed line" "$FILE2"
    assert_output ''
    diff -y "$FILE2" "$EXISTING"
}

@test "test-only update with existing marker and same multi-line block returns 99" {
    run -99 updateBlock --test-only --marker test --block-text $'The original comment\nis this one.' "$FILE2"
    assert_output ''
    diff -y "$FILE2" "$EXISTING"
}

@test "test-only update with existing marker and different multi-line block succeeds" {
    run -0 updateBlock --test-only --marker test --block-text $'across\nmultiple\nlines' "$FILE2"
    assert_output ''
    diff -y "$FILE2" "$EXISTING"
}
