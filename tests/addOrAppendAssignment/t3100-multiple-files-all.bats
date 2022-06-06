#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 1" {
    run addOrAppendAssignment --all --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update all with existing assignment in first file appends at the end of the other files" {
    addOrAppendAssignment --all --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = 'foo="bar"
quux="initial value"
fox="hi"
foy=""' ]
    [ "$(cat "$FILE3")" = "$(cat "$MORE3")
fox=\"hi\"" ]
}

@test "update all with existing assignment in one file appends at the end of the two other files only" {
    addOrAppendAssignment --all --in-place --lhs fox --rhs hi "$FILE2" "$FILE3" "$FILE"
    [ "$(cat "$FILE2")" = 'foo="bar"
quux="initial value"
fox="hi"
foy=""' ]
    [ "$(cat "$FILE3")" = "$(cat "$MORE3")
fox=\"hi\"" ]
    cmp "$FILE" "$INPUT"
}

@test "update all with nonexisting assignment appends to all files" {
    addOrAppendAssignment --all --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "$(cat "$INPUT")
new=\"add\"" ]
    [ "$(cat "$FILE2")" = "$(cat "$MORE2")
new=\"add\"" ]
    [ "$(cat "$FILE3")" = "$(cat "$MORE3")
new=\"add\"" ]
}
