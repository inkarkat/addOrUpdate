#!/usr/bin/env bats

load temp

@test "update all updates all files" {
    UPDATE="foo=new"
    updateLine --all --in-place --update-match "foo=bar" --replacement "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi" ]
    [ "$(cat "$FILE2")" = "$UPDATE
quux=initial
foo=moo bar baz" ]
    [ "$(cat "$FILE3")" = "zulu=here
$UPDATE
foo=no bar baz" ]
}

@test "update all with match in second file updates that file" {
    UPDATE="quux=updated"
    run updateLine --all --in-place --update-match "quux=.*" --replacement "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 0 ]
    cmp "$INPUT" "$FILE"
    [ "$(cat "$FILE2")" = "foo=bar
$UPDATE
foo=moo bar baz" ]
    cmp "$FILE3" "$MORE3"
}

@test "update all with existing line in all files keeps contents and returns 1" {
    run updateLine --all --in-place --update-match "foo=bar" --replacement '&' "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update all with existing line in first file returns 1" {
    UPDATE="foo=hoo bar baz"
    run updateLine --all --in-place --update-match "$UPDATE" --replacement '&' "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update all with existing line in one file returns 1" {
    UPDATE="foo=hoo bar baz"
    run updateLine --all --in-place --update-match "$UPDATE" --replacement '&' "$FILE2" "$FILE3" "$FILE"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update all with nonexisting line returns 1" {
    run updateLine --all --in-place --update-match "foosball=never" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}
