#!/usr/bin/env bats

load temp

@test "update with existing last line assignment keeps contents and returns 99" {
    run addOrUpdateAssignment --lhs fox --rhs hi "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing last line assignment keeps contents and returns 99" {
    run addOrUpdateAssignment --in-place --lhs fox --rhs hi "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}

@test "update with existing assignment on the add-before line keeps contents and returns 99" {
    run addOrUpdateAssignment --lhs foo --rhs bar --add-before 2 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing assignment on the add-after line keeps contents and returns 99" {
    run addOrUpdateAssignment --lhs foo --rhs bar --add-after 2 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing assignment on the add-before line keeps contents and returns 99" {
    run addOrUpdateAssignment --in-place --lhs foo --rhs bar --add-before 2 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}

@test "in-place update with existing assignment on the add-after line keeps contents and returns 99" {
    run addOrUpdateAssignment --in-place --lhs foo --rhs bar --add-after 2 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}
