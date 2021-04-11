#!/usr/bin/env bats

load temp

@test "update with pre and post lines that contain special characters and assignment" {
    PRELINE='/new&header\'
    POSTLINE='\new&footer/'
    run updateAssignment --pre-update "$PRELINE" --post-update "$POSTLINE" --lhs foo --rhs new "$FILE"
    [ "$output" = "sing/e=wha\\ever
$PRELINE
foo=new
$POSTLINE
foo=hoo bar baz
# SECTION
fox=hi" ]
}
