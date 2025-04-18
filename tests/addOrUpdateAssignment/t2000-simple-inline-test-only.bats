#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends at the end" {
    run -0 addOrUpdateAssignment --lhs add --rhs new "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
add=new
EOF
}

@test "update with existing assignment keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --lhs foo --rhs bar "$FILE"
    assert_output - < "$INPUT"
}

@test "update with nonexisting assignment containing forward and backslash appends at the end" {
    run -0 addOrUpdateAssignment --lhs '/new\' --rhs '\here/' "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
/new\=\here/
EOF
}

@test "update with existing assignment containing forward and backslash keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --lhs 'sing/e' --rhs 'wha\ever' "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with nonexisting assignment appends at the end" {
    run -0 addOrUpdateAssignment --in-place --lhs add --rhs new "$FILE"
    assert_output ''
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
add=new
EOF
}

@test "in-place update with existing assignment keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --in-place --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with nonexisting assignment succeeds" {
    run -0 addOrUpdateAssignment --test-only --lhs add --rhs new "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing assignment returns 99" {
    run -99 addOrUpdateAssignment --test-only --lhs foo --rhs bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
