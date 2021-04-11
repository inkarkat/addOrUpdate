#!/usr/bin/env bats

load temp

@test "update with updated assignment on the passed line updates that line" {
    run updateAssignment --lhs foo --rhs boo --add-before 2 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\ever
foo=boo
foo=hoo bar baz
# SECTION
fox=hi" ]
}

@test "update with existing assignment one after the passed line keeps contents and returns 1" {
    run updateAssignment --lhs foo --rhs bar --add-before 1 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
