#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips post line and returns 1" {
    POSTLINE="# new footer"
    run updateLine --post-update "$POSTLINE" --update-match "foosball=never" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with one post line and line" {
    POSTLINE="# new footer"
    UPDATE='foo=not here'
    run updateLine --post-update "$POSTLINE" --update-match "foo=h.*" --replacement "$UPDATE" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE
# SECTION
foo=hi" ]
}

