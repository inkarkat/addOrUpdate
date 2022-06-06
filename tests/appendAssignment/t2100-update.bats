#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run appendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with assignee containing forward slash updates" {
    run appendAssignment --lhs 'sing/e' --rhs 'whe\reever' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever whe\reever"
foo="bar"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}
