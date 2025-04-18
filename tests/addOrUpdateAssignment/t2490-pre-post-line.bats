#!/usr/bin/env bats

load temp

@test "append with pre and post lines" {
    PRELINE1='# new header'
    PRELINE2='more

stuff'
    POSTLINE1='more

stuff'
    POSTLINE2='# new footer'
    run addOrUpdateAssignment --pre-line "$PRELINE1" --post-line "$POSTLINE1" --pre-line "$PRELINE2" --post-line "$POSTLINE2" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE1
$PRELINE2
new=add
$POSTLINE1
$POSTLINE2
EOF
}

@test "append with pre and post lines that contain backslashes" {
    PRELINE='/new header\'
    POSTLINE='\new footer/'
    run addOrUpdateAssignment --pre-line "$PRELINE" --post-line "$POSTLINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE
new=add
$POSTLINE
EOF
}

@test "append with pre and post lines is not using pre and post update lines" {
    PRELINE1='# new header'
    PRELINE2='more

stuff'
    POSTLINE1='more

stuff'
    POSTLINE2='# new footer'
    run addOrUpdateAssignment --pre-line "$PRELINE1" --post-line "$POSTLINE1" --pre-line "$PRELINE2" --post-line "$POSTLINE2" --pre-update "# not in" --post-update '# also not'  --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE1
$PRELINE2
new=add
$POSTLINE1
$POSTLINE2
EOF
}
