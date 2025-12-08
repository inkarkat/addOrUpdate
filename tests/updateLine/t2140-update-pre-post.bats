#!/usr/bin/env bats

load temp

@test "update with pre and post lines that contain special characters and line" {
    PRELINE='/new&header\'
    UPDATE='foo=new'
    POSTLINE='\new&footer/'
    run -0 updateLine --pre-update "$PRELINE" --post-update "$POSTLINE" --update-match "foo=h.*" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
$UPDATE
$POSTLINE
# SECTION
foo=hi
EOF
}
