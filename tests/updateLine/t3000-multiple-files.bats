#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    UPDATE="foo=new"
    updateLine --in-place --update-match "foo=bar" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
foo=barfoo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    updateLine --in-place --update-match "quux=" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = "foo=bar
quux=quux=initial
foo=moo bar baz" ]
    cmp "$FILE3" "$MORE3"
}

@test "update with existing line in all files keeps contents and returns 99" {
    run updateLine --in-place --update-match "foo=b.*" --replacement 'foo=bar' "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 99 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with existing line in first file returns 1" {
    UPDATE="foo=hoo bar baz"
    run updateLine --in-place --update-match "foo=h.*" --replacement "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with nonexisting line returns 1" {
    UPDATE="foo=new"
    run updateLine --in-place --update-match "foosball=never" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}
