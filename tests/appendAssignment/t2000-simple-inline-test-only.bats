#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run -1 appendAssignment --lhs add --rhs new "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing assignment keeps contents and returns 99" {
    run -99 appendAssignment --lhs foo --rhs bar "$FILE"
    assert_output - < "$INPUT"
}

@test "update with nonexisting assignment containing forward and backslash returns 1" {
    run -1 appendAssignment --lhs '/new\' --rhs '\here/' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing assignment containing forward and backslash keeps contents and returns 99" {
    run -99 appendAssignment --lhs 'sing/e' --rhs 'wha\ever' "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with nonexisting assignment returns 1" {
    run -1 appendAssignment --in-place --lhs add --rhs new "$FILE"
    assert_output ''
    assert_equal "$(<"$FILE")" "$(cat "$INPUT")"
}

@test "in-place update with existing assignment keeps contents and returns 99" {
    run -99 appendAssignment --in-place --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with nonexisting assignment returns 1" {
    run -1 appendAssignment --test-only --lhs add --rhs new "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing assignment returns 99" {
    run -99 appendAssignment --test-only --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
