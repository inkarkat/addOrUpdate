#!/usr/bin/env bats

load temp

@test "update with existing assignment after the passed line keeps contents and returns 1" {
    run updateAssignment --lhs foo --rhs bar --add-after 3 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
