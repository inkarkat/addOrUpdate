#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run updateAssignment --lhs add --rhs new "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing assignment keeps contents and returns 1" {
    run updateAssignment --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing assignment containing forward and backslash keeps contents and returns 1" {
    run updateAssignment --lhs 'sing/e' --rhs 'wha\ever' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing assignment keeps contents and returns 1" {
    run updateAssignment --in-place --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with existing assignment returns 1" {
    run updateAssignment --test-only --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}
