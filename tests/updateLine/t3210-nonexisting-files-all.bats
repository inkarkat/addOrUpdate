#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    UPDATE="foo=new"
    run updateLine --all --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi" ]
    [ "$(cat "$FILE2")" = "$UPDATE
quux=initial
foo=moo bar baz" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "all nonexisting all files returns 4" {
    UPDATE="foo=new"
    run updateLine --all --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
