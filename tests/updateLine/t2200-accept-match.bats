#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern returns 1" {
    run -1 updateLine --accept-match "foosball=never" --update-match "foosball=never" --replacement '&&' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with literal-like pattern keeps contents and returns 99" {
    run -99 updateLine --accept-match "foo=h" --update-match "foo=new" --replacement '&&' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with anchored pattern keeps contents and returns 99" {
    run -99 updateLine --accept-match "^fo\+=[ghi].*$" --update-match "foo=new" --replacement '&&' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with pattern containing forward and backslash keeps contents and returns 99" {
    run -99 updateLine --accept-match '^.*/.=.*\\.*' --update-match "foo=new" --replacement '&&' "$FILE"
    assert_output - < "$INPUT"
}
