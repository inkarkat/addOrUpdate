#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends after the passed line" {
    run addOrAppendAssignment --lhs new --rhs add --add-after 3 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar"
foo="hoo bar baz"
new="add"
# SECTION
fox="hi there"' ]
}

@test "update with nonexisting assignment appends after the passed ADDRESS" {
    run addOrAppendAssignment --lhs new --rhs add --add-after '/^#/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar"
foo="hoo bar baz"
# SECTION
new="add"
fox="hi there"' ]
}

@test "update with nonexisting assignment appends after the first match of ADDRESS only" {
    run addOrAppendAssignment --lhs new --rhs add --add-after '/^foo=/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar"
new="add"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}

@test "update with existing assignment after the passed line keeps contents and returns 1" {
    run addOrAppendAssignment --lhs foo --rhs bar --add-after 3 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
