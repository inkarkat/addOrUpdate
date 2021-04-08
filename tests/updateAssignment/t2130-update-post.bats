#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment skips post line and returns 1" {
    POSTLINE="# new footer"
    run updateAssignment --post-update "$POSTLINE" --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with one post line and assignment" {
    POSTLINE="# new footer"
    run updateAssignment --post-update "$POSTLINE" --lhs foo --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=new
$POSTLINE
foo=hoo bar baz
# SECTION
fox=hi" ]
}

