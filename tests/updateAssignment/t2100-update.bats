#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run updateAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with assignee containing forward slash updates" {
    run updateAssignment --lhs 'sing/e' --rhs 'whe\reever' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=whe\reever
foo=bar
foo=hoo bar baz
# SECTION
fox=hi' ]
}
