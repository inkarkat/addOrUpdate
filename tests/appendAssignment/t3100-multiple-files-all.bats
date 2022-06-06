#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 1" {
    run appendAssignment --all --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update all with existing assignment in first file updates that file" {
    appendAssignment --all --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = 'foo="bar"
quux="initial value"
fox="hi"
foy=""' ]
    cmp "$FILE3" "$MORE3"
}

@test "update all with existing assignment in one file updates that file" {
    appendAssignment --all --in-place --lhs fox --rhs hi "$FILE2" "$FILE3" "$FILE"
    [ "$(cat "$FILE2")" = 'foo="bar"
quux="initial value"
fox="hi"
foy=""' ]
    cmp "$FILE3" "$MORE3"
    cmp "$FILE" "$INPUT"
}

@test "update all with nonexisting assignment returns 1" {
    run appendAssignment --all --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$INPUT" "$FILE"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}
