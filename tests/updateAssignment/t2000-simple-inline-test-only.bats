#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run -1 updateAssignment --lhs add --rhs new "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing assignment keeps contents and returns 99" {
    run -99 updateAssignment --lhs foo --rhs bar "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing assignment containing forward and backslash keeps contents and returns 99" {
    run -99 updateAssignment --lhs 'sing/e' --rhs 'wha\ever' "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with existing assignment keeps contents and returns 99" {
    run -99 updateAssignment --in-place --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing assignment returns 99" {
    run -99 updateAssignment --test-only --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
