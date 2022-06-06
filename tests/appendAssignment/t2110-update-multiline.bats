#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run appendAssignment --lhs new --rhs $'multi\nline' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with value of multiple lines" {
    run appendAssignment --lhs foo --rhs $'multi\nline' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar multi
line"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}
