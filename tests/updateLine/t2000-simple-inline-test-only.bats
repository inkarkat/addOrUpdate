#!/usr/bin/env bats

load temp

@test "update with nonexisting match returns 1" {
    run -1 updateLine --update-match "foosball=never" --replacement '&&' "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with nonexisting line returns 1" {
    run -1 updateLine --in-place --update-match "foosball=never" --replacement '&&' "$FILE"
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with nonexisting line returns 1" {
    run -1 updateLine --test-only --update-match "foosball=never" --replacement '&&' "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
