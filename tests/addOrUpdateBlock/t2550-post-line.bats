#!/usr/bin/env bats

load temp

@test "append with one post line" {
    POSTLINE='# new footer'
    run -0 addOrUpdateBlock --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$BLOCK
$POSTLINE
EOF
}

@test "append with three separate post lines" {
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    run -0 addOrUpdateBlock --post-line "$POSTLINE1" --post-line "$POSTLINE2" --post-line "$POSTLINE3" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$BLOCK
$POSTLINE1
$POSTLINE2
$POSTLINE3
EOF
}

@test "append with one multi-line post line" {
    POSTLINE='# first footer

# third footer'
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    run -0 addOrUpdateBlock --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$BLOCK
$POSTLINE1
$POSTLINE2
$POSTLINE3
EOF
}

addOrUpdateLineWithPeriod()
{
    addOrUpdateBlock "$@"; printf .
}

@test "empty post line" {
    run -0 addOrUpdateLineWithPeriod --post-line '' --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$BLOCK

.
EOF
}

@test "empty and non-empty post lines" {
    run -0 addOrUpdateLineWithPeriod --post-line '' --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$BLOCK

$POSTLINE
.
EOF
}

@test "non-empty and empty post lines" {
    run -0 addOrUpdateLineWithPeriod --post-line "$POSTLINE" --post-line '' --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$BLOCK
$POSTLINE

.
EOF
}

@test "single space post line" {
    POSTLINE=" "
    run -0 addOrUpdateLineWithPeriod --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$BLOCK
${POSTLINE}
.
EOF
}
