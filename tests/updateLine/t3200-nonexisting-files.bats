#!/usr/bin/env bats

load temp

@test "update in first existing file skips nonexisting files" {
    UPDATE="foo=new"
    run updateLine --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi" ]
    cmp "$FILE2" "$MORE2"
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "all nonexisting files returns 4" {
    UPDATE="foo=new"
    run updateLine --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
