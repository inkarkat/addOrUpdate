#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends at the end" {
    run addOrAppendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=\"add\"" ]
}

@test "update with assignee containing forward slash updates" {
    run addOrAppendAssignment --lhs 'sing/e' --rhs 'whe\reever' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever whe\reever"
foo="bar"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}
