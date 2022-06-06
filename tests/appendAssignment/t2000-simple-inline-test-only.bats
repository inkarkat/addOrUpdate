#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run appendAssignment --lhs add --rhs new "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing assignment keeps contents and returns 1" {
    run appendAssignment --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with nonexisting assignment containing forward and backslash returns 1" {
    run appendAssignment --lhs '/new\' --rhs '\here/' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing assignment containing forward and backslash keeps contents and returns 1" {
    run appendAssignment --lhs 'sing/e' --rhs 'wha\ever' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with nonexisting assignment returns 1" {
    run appendAssignment --in-place --lhs add --rhs new "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing assignment keeps contents and returns 1" {
    run appendAssignment --in-place --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with nonexisting assignment returns 1" {
    run appendAssignment --test-only --lhs add --rhs new "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with existing assignment returns 1" {
    run appendAssignment --test-only --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}
