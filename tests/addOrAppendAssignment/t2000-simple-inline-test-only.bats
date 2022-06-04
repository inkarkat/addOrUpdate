#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends at the end" {
    run addOrAppendAssignment --lhs add --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
add=\"new\"" ]
}

@test "update with existing assignment keeps contents and returns 1" {
    run addOrAppendAssignment --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with nonexisting assignment containing forward and backslash appends at the end" {
    run addOrAppendAssignment --lhs '/new\' --rhs '\here/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
/new\\=\"\\here/\"" ]
}

@test "update with existing assignment containing forward and backslash keeps contents and returns 1" {
    run addOrAppendAssignment --lhs 'sing/e' --rhs 'wha\ever' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with nonexisting assignment appends at the end" {
    run addOrAppendAssignment --in-place --lhs add --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "$(cat "$INPUT")
add=\"new\"" ]
}

@test "in-place update with existing assignment keeps contents and returns 1" {
    run addOrAppendAssignment --in-place --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with nonexisting assignment succeeds" {
    run addOrAppendAssignment --test-only --lhs add --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with existing assignment returns 1" {
    run addOrAppendAssignment --test-only --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}
