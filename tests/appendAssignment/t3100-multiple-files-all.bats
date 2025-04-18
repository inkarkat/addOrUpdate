#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 99" {
    run -99 appendAssignment --all --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing assignment in first file updates that file" {
    appendAssignment --all --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo="bar"
quux="initial value"
fox="hi"
foy=""
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing assignment in one file updates that file" {
    appendAssignment --all --in-place --lhs fox --rhs hi "$FILE2" "$FILE3" "$FILE"
    diff -y - --label expected "$FILE2" <<'EOF'
foo="bar"
quux="initial value"
fox="hi"
foy=""
EOF
    diff -y "$FILE3" "$MORE3"
    diff -y "$FILE" "$INPUT"
}

@test "update all with nonexisting assignment returns 1" {
    run -1 appendAssignment --all --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    diff -y "$INPUT" "$FILE"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}
