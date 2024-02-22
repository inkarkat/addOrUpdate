#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    addOrAppendAssignment --in-place --lhs foo --rhs new "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = 'sing/e="wha\ever"
foo="bar new"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    addOrAppendAssignment --in-place --lhs quux --rhs new "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = 'foo="bar"
quux="initial value new"
fox=
foy=""' ]
    cmp "$FILE3" "$MORE3"
}

@test "update with existing assignment in all files keeps contents and returns 99" {
    run addOrAppendAssignment --in-place --lhs foo --rhs bar "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 99 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with existing assignment in first file updates in the second file" {
    addOrAppendAssignment --in-place --lhs fox --rhs hi "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = 'foo="bar"
quux="initial value"
fox="hi"
foy=""' ]
    cmp "$FILE3" "$MORE3"
}

@test "update with nonexisting assignment appends at the end of the last file only" {
    addOrAppendAssignment --in-place --lhs new --rhs add "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    [ "$(cat "$FILE3")" = "$(cat "$MORE3")
new=\"add\"" ]
}
