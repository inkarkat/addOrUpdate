#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends at the end" {
    run -0 addOrAppendAssignment --lhs add --rhs new "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
add="new"
EOF
}

@test "update with existing assignment keeps contents and returns 99" {
    run -99 addOrAppendAssignment --lhs foo --rhs bar "$FILE"
    assert_output - < "$INPUT"
}

@test "update with nonexisting assignment containing forward and backslash appends at the end" {
    run -0 addOrAppendAssignment --lhs '/new\' --rhs '\here/' "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
/new\="\here/"
EOF
}

@test "update with existing assignment containing forward and backslash keeps contents and returns 99" {
    run -99 addOrAppendAssignment --lhs 'sing/e' --rhs 'wha\ever' "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with nonexisting assignment appends at the end" {
    run -0 addOrAppendAssignment --in-place --lhs add --rhs new "$FILE"
    assert_output ''
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
add="new"
EOF
}

@test "in-place update with existing assignment keeps contents and returns 99" {
    run -99 addOrAppendAssignment --in-place --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with nonexisting assignment succeeds" {
    run -0 addOrAppendAssignment --test-only --lhs add --rhs new "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing assignment returns 99" {
    run -99 addOrAppendAssignment --test-only --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
