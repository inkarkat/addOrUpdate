#!/usr/bin/env bats

load temp

@test "test-only update with nonexisting marker returns 1" {
    run updateBlock --test-only --marker test --block-text "single-line" "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$FRESH"
}

@test "test-only update with nonexisting marker returns 1" {
    run updateBlock --test-only --marker test --block-text $'across\nmultiple\nlines' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$FRESH"
}

@test "test-only update with existing marker and same single-line block returns 1" {
    run updateBlock --test-only --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE2" "$EXISTING"
}

@test "test-only update with existing marker and different single-line block succeeds" {
    run updateBlock --test-only --marker subsequent --block-text "Changed line" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE2" "$EXISTING"
}

@test "test-only update with existing marker and same multi-line block returns 1" {
    run updateBlock --test-only --marker test --block-text $'The original comment\nis this one.' "$FILE2"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE2" "$EXISTING"
}

@test "test-only update with existing marker and different multi-line block succeeds" {
    run updateBlock --test-only --marker test --block-text $'across\nmultiple\nlines' "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE2" "$EXISTING"
}
