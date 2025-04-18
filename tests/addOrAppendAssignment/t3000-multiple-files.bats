#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    addOrAppendAssignment --in-place --lhs foo --rhs new "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<'EOF'
sing/e="wha\ever"
foo="bar new"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    addOrAppendAssignment --in-place --lhs quux --rhs new "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo="bar"
quux="initial value new"
fox=
foy=""
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing assignment in all files keeps contents and returns 99" {
    run -99 addOrAppendAssignment --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing assignment in first file updates in the second file" {
    addOrAppendAssignment --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo="bar"
quux="initial value"
fox="hi"
foy=""
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update with nonexisting assignment appends at the end of the last file only" {
    addOrAppendAssignment --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
new="add"
EOF
}
