#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --all --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing assignment in first file appends at the end of the other files" {
    addOrUpdateAssignment --all --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<EOF
$(cat "$MORE2")
fox=hi
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
fox=hi
EOF
}

@test "update all with existing assignment in one file appends at the end of the two other files only" {
    addOrUpdateAssignment --all --in-place --lhs fox --rhs hi "$FILE2" "$FILE3" "$FILE"
    diff -y - --label expected "$FILE2" <<EOF
$(cat "$MORE2")
fox=hi
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
fox=hi
EOF
    diff -y "$FILE" "$INPUT"
}

@test "update all with nonexisting assignment appends to all files" {
    addOrUpdateAssignment --all --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
new=add
EOF
    diff -y - --label expected "$FILE2" <<EOF
$(cat "$MORE2")
new=add
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
new=add
EOF
}
