#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 99" {
    run updateAssignment --all --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 99 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update all with updated assignment in second file updates that file" {
    run updateAssignment --all --in-place --lhs quux --rhs new "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 0 ]
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = "foo=bar
quux=new
foo=moo bar baz" ]
    cmp "$FILE3" "$MORE3"
}

@test "update all with nonexisting assignment returns 1" {
    UPDATE="foo=new"
    run updateAssignment --all --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}
