#!/usr/bin/env bats

load temp

@test "update with pre and post lines that contain special characters and assignment" {
    PRELINE='/new&header\'
    POSTLINE='\new&footer/'
    run -0 updateAssignment --pre-update "$PRELINE" --post-update "$POSTLINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$PRELINE
foo=new
$POSTLINE
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
