#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run updateAssignment --all --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
foo=new
foo=hoo bar baz
# SECTION
fox=hi" ]
    [ "$(cat "$FILE2")" = "foo=new
quux=initial
foo=moo bar baz" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "all nonexisting all files returns 4" {
    run updateAssignment --all --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
