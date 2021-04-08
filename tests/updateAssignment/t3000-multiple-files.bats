#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    updateAssignment --in-place --lhs foo --rhs new "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
foo=new
foo=hoo bar baz
# SECTION
fox=hi" ]
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    updateAssignment --in-place --lhs quux --rhs new "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = "foo=bar
quux=new
foo=moo bar baz" ]
    cmp "$FILE3" "$MORE3"
}

@test "update with existing assignment in all files keeps contents and returns 1" {
    run updateAssignment --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with existing assignment in first file returns 1" {
    run updateAssignment --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with nonexisting assignment returns 1" {
    run updateAssignment --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}
