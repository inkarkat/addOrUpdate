#!/usr/bin/env bats

load temp

@test "update with pattern matching partial line uses pre and post lines that contain special characters and REPLACEMENT just for match" {
    PRELINE='/new&header\'
    POSTLINE='\new&footer/'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --post-update "$POSTLINE" --line "foo=new" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
fox=replaced bar baz
$POSTLINE
# SECTION
foo=hi
EOF
}
