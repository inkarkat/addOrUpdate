#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run appendAssignment --all --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = 'sing/e="wha\ever"
foo="bar new"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
    [ "$(cat "$FILE2")" = 'foo="bar new"
quux="initial value"
fox=
foy=""' ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "all nonexisting all files returns 4" {
    run appendAssignment --all --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
