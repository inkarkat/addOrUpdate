#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 99" {
    run -99 updateAssignment --all --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing assignment in first file keeps contents and returns 1" {
    run -1 updateAssignment --all --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with updated assignment in second file updates that file and returns 1" {
    run -1 updateAssignment --all --in-place --lhs quux --rhs new "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo=bar
quux=new
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update all with nonexisting assignment returns 1" {
    run -1 updateAssignment --all --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}
