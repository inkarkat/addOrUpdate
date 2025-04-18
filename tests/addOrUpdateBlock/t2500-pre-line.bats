#!/usr/bin/env bats

load temp

@test "append with one pre line" {
    PRELINE='# new header'
    run -0 addOrUpdateBlock --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$PRELINE
$BLOCK
EOF
}

@test "append with three separate pre lines" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateBlock --pre-line "$PRELINE1" --pre-line "$PRELINE2" --pre-line "$PRELINE3" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$PRELINE1
$PRELINE2
$PRELINE3
$BLOCK
EOF
}

@test "append with one multi-line pre line" {
    PRELINE='# first header

# third header'
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateBlock --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$PRELINE1
$PRELINE2
$PRELINE3
$BLOCK
EOF
}

@test "empty pre line" {
    run -0 addOrUpdateBlock --pre-line '' --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")

$BLOCK
EOF
}

@test "empty and non-empty pre lines" {
    run -0 addOrUpdateBlock --pre-line '' --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")

$PRELINE
$BLOCK
EOF
}

@test "non-empty and empty pre lines" {
    run -0 addOrUpdateBlock --pre-line "$PRELINE" --pre-line '' --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$PRELINE

$BLOCK
EOF
}

@test "single space pre line" {
    PRELINE=' '
    run -0 addOrUpdateBlock --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
$PRELINE
$BLOCK
EOF
}
