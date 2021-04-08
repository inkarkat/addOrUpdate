#!/usr/bin/env bats

load temp

@test "update with pattern matching partial line uses pre and post lines that contain special characters and REPLACEMENT just for match" {
    PRELINE='/new&header\'
    POSTLINE='\new&footer/'
    run updateLine --pre-update "$PRELINE" --post-update "$POSTLINE" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    [ "$output" = "sing/e=wha\\ever
foo=bar
$PRELINE
fox=replaced bar baz
$POSTLINE
# SECTION
foo=hi" ]
}
