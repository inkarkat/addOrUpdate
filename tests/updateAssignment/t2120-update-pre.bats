#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips pre line and returns 1" {
    PRELINE="# new header"
    run updateAssignment --pre-update "$PRELINE" --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with one pre line and assignment" {
    PRELINE="# new header"
    run updateAssignment --pre-update "$PRELINE" --lhs foo --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
$PRELINE
foo=new
foo=hoo bar baz
# SECTION
fox=hi" ]
}

