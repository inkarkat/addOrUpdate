#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern appends at the end" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --accept-match "foosball=never" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
$UPDATE" ]
}

@test "update with literal-like pattern keeps contents and returns 1" {
    run addOrUpdateLine --line "foo=new" --accept-match "foo=h" "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with anchored pattern keeps contents and returns 1" {
    run addOrUpdateLine --line "foo=new" --accept-match "^fo\+=[ghi].*$" "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with pattern containing forward and backslash keeps contents and returns 1" {
    run addOrUpdateLine --line 'foo=/e\' --accept-match '^.*/.=.*\\.*' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
