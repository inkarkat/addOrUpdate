#!/usr/bin/env bats

load temp

@test "append with pre and post lines" {
    PRELINE1='# new header'
    PRELINE2='more

stuff'
    POSTLINE1='more

stuff'
    POSTLINE2='# new footer'
    run -0 addOrUpdateBlock --pre-line "$PRELINE1" --post-line "$POSTLINE1" --pre-line "$PRELINE2" --post-line "$POSTLINE2" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$PRELINE1
$PRELINE2
$BLOCK
$POSTLINE1
$POSTLINE2
EOF
}
