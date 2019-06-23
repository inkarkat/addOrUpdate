#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    init
    UPDATE="foo=new"
    addOrUpdate --in-place --line "$UPDATE" --update-match "foo=bar" "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi" ]
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    init
    UPDATE="quux=updated"
    addOrUpdate --in-place --line "$UPDATE" --update-match "quux=" "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = "foo=bar
$UPDATE
foo=moo bar baz" ]
    cmp "$FILE3" "$MORE3"
}

@test "update with existing line in all files keeps contents and returns 1" {
    init
    run addOrUpdate --in-place --line "foo=bar" "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with existing line in first file appends at the end of the last file only" {
    init
    UPDATE="foo=hoo bar baz"
    addOrUpdate --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    [ "$(cat "$FILE3")" = "$(cat "$MORE3")
$UPDATE" ]
}

@test "update with nonexisting line appends at the end of the last file only" {
    init
    UPDATE="foo=new"
    addOrUpdate --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    [ "$(cat "$FILE3")" = "$(cat "$MORE3")
$UPDATE" ]
}

