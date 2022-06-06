#!/usr/bin/env bats

load temp

@test "update with existing last line assignment keeps contents and returns 1" {
    run addOrAppendAssignment --lhs fox --rhs 'hi there' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing last line assignment keeps contents and returns 1" {
    run addOrAppendAssignment --in-place --lhs fox --rhs 'hi there' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}

@test "update with existing assignment on the add-before line keeps contents and returns 1" {
    run addOrAppendAssignment --lhs foo --rhs bar --add-before 2 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing assignment on the add-after line keeps contents and returns 1" {
    run addOrAppendAssignment --lhs foo --rhs bar --add-after 2 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing assignment on the add-before line keeps contents and returns 1" {
    run addOrAppendAssignment --in-place --lhs foo --rhs bar --add-before 2 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}

@test "in-place update with existing assignment on the add-after line keeps contents and returns 1" {
    run addOrAppendAssignment --in-place --lhs foo --rhs bar --add-after 2 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}
