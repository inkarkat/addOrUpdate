#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern appends at the end" {
    run addOrUpdateAssignment --lhs new --rhs add --accept-match "foosball=never" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=add" ]
}

@test "update with literal-like pattern keeps contents and returns 99" {
    run addOrUpdateAssignment --lhs foo --rhs new --accept-match "foo=b" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with anchored pattern keeps contents and returns 99" {
    run addOrUpdateAssignment --lhs foo --rhs new --accept-match "^fo\+=[abc].*$" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with pattern containing forward and backslash keeps contents and returns 99" {
    run addOrUpdateAssignment --lhs foo --rhs '/e\' --accept-match "^.*/.=.*\\.*" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
