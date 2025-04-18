#!/usr/bin/env bats

load temp

@test "update with existing last line assignment keeps contents and returns 99" {
    run -99 updateAssignment --lhs fox --rhs hi "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with existing last line assignment keeps contents and returns 99" {
    run -99 updateAssignment --in-place --lhs fox --rhs hi "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}

@test "update with existing assignment on the add-before line keeps contents and returns 99" {
    run -99 updateAssignment --lhs foo --rhs bar --add-before 2 "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing assignment on the add-after line keeps contents and returns 99" {
    run -99 updateAssignment --lhs foo --rhs bar --add-after 2 "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with existing assignment on the add-before line keeps contents and returns 99" {
    run -99 updateAssignment --in-place --lhs foo --rhs bar --add-before 2 "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}

@test "in-place update with existing assignment on the add-after line keeps contents and returns 99" {
    run -99 updateAssignment --in-place --lhs foo --rhs bar --add-after 2 "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}
