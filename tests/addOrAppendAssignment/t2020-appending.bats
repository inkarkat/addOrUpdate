#!/usr/bin/env bats

load temp

@test "update appends to existing value" {
    run addOrAppendAssignment --lhs foo --rhs added "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e="wha\ever"
foo="bar added"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
}

@test "update inserts to empty quoted value" {
    run addOrAppendAssignment --lhs foy --rhs added "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = 'foo="bar"
quux="initial value"
fox=
foy="added"' ]
}

@test "update inserts to empty unquoted value" {
    run addOrAppendAssignment --lhs fox --rhs added "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = 'foo="bar"
quux="initial value"
fox="added"
foy=""' ]
}
