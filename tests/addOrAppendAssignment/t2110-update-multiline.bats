#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends multi-line at the end" {
    run addOrAppendAssignment --lhs new --rhs $'multi\nline' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=\"multi
line\"" ]
}

@test "update with value of multiple lines" {
    run addOrAppendAssignment --lhs foo --rhs $'multi\nline' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar multi
line"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}
