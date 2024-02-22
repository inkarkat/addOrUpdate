#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment inserts on the passed line" {
    run addOrAppendAssignment --lhs new --rhs add --add-before 4 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar"
foo="hoo bar baz"
new="add"
# SECTION
fox="hi there"' ]
}

@test "update with nonexisting assignment inserts on the passed ADDRESS" {
    run addOrAppendAssignment --lhs new --rhs add --add-before '/^#/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar"
foo="hoo bar baz"
new="add"
# SECTION
fox="hi there"' ]
}

@test "update with nonexisting assignment inserts on the first match of ADDRESS only" {
    run addOrAppendAssignment --lhs new --rhs add --add-before '/^foo=/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
new="add"
foo="bar"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}

@test "update with existing assignment on the passed line keeps contents and returns 99" {
    run addOrAppendAssignment --lhs foo --rhs bar --add-before 2 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing assignment one before the passed line keeps contents and returns 1" {
    run addOrAppendAssignment --lhs foo --rhs bar --add-before 1 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'foo="bar"
sing/e="wha\ever"
foo="bar"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}
