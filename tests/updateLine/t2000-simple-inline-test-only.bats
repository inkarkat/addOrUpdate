#!/usr/bin/env bats

load temp

@test "update with nonexisting match returns 1" {
    run updateLine --update-match "foosball=never" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with nonexisting line returns 1" {
    run updateLine --in-place --update-match "foosball=never" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with nonexisting line returns 1" {
    run updateLine --test-only --update-match "foosball=never" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}
