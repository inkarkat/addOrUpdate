#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern returns 1" {
    UPDATE="foo=new"
    run updateLine --accept-match "foosball=never" --update-match "foosball=never" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with literal-like pattern keeps contents and returns 1" {
    run updateLine --accept-match "foo=h" --update-match "foo=new" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with anchored pattern keeps contents and returns 1" {
    run updateLine --accept-match "^fo\+=[ghi].*$" --update-match "foo=new" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with pattern containing forward and backslash keeps contents and returns 1" {
    run updateLine --accept-match '^.*/.=.*\\.*' --update-match "foo=new" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
