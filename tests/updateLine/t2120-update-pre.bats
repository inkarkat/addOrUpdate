#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips pre line and returns 1" {
    PRELINE="# new header"
    run updateLine --pre-update "$PRELINE" --update-match "foosball=never" --replacement '&&' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with one pre line and line" {
    PRELINE="# new header"
    UPDATE='foo=not here'
    run updateLine --pre-update "$PRELINE" --update-match "foo=h.*" --replacement "$UPDATE" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$PRELINE
$UPDATE
# SECTION
foo=hi" ]
}

