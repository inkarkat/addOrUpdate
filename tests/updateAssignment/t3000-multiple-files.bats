#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    updateAssignment --in-place --lhs foo --rhs new "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    updateAssignment --in-place --lhs quux --rhs new "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo=bar
quux=new
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing assignment in all files keeps contents and returns 99" {
    run -99 updateAssignment --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing assignment in first file returns 1" {
    run -1 updateAssignment --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with nonexisting assignment returns 1" {
    run -1 updateAssignment --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}
