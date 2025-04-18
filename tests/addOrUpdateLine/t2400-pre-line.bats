#!/usr/bin/env bats

load temp

@test "append with one pre line" {
    PRELINE='# new header'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --pre-line "$PRELINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE
$UPDATE
EOF
}

@test "append with three separate pre lines" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    UPDATE="foo=new"
    run -0 addOrUpdateLine --pre-line "$PRELINE1" --pre-line "$PRELINE2" --pre-line "$PRELINE3" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE1
$PRELINE2
$PRELINE3
$UPDATE
EOF
}

@test "append with one multi-line pre line" {
    PRELINE='# first header

# third header'
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --pre-line "$PRELINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE1
$PRELINE2
$PRELINE3
$UPDATE
EOF
}

@test "empty pre line" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --pre-line '' --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")

$UPDATE
EOF
}

@test "empty and non-empty pre lines" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --pre-line '' --pre-line "$PRELINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")

$PRELINE
$UPDATE
EOF
}

@test "non-empty and empty pre lines" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --pre-line "$PRELINE" --pre-line '' --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE

$UPDATE
EOF
}

@test "single space pre line" {
    PRELINE=' '
    UPDATE='foo=new'
    run -0 addOrUpdateLine --pre-line "$PRELINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE
$UPDATE
EOF
}
