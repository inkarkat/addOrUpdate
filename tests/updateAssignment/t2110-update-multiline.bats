#!/usr/bin/env bats

load temp

@test "update with value of multiple lines" {
    run updateAssignment --lhs foo --rhs $'multi\nline' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=multi
line
foo=hoo bar baz
# SECTION
fox=hi" ]
}
