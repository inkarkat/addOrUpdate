#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips pre line and appends at the end" {
    PRELINE='# new header'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "$UPDATE" --update-match "foosball=never" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with one pre line and line" {
    PRELINE='# new header'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
$UPDATE
# SECTION
foo=hi
EOF
}

@test "identical update skips pre line" {
    PRELINE='# new header'
    run -99 addOrUpdateLine --line 'foo=new' --pre-update "$PRELINE" --update-match '^foo=b.*' --replacement 'foo=bar' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with three separate pre lines and line" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --pre-update "$PRELINE1" --pre-update "$PRELINE2" --pre-update "$PRELINE3" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE1
$PRELINE2
$PRELINE3
$UPDATE
# SECTION
foo=hi
EOF
}

@test "update with one multi-line pre line and line" {
    PRELINE='# first header

# third header'
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE1
$PRELINE2
$PRELINE3
$UPDATE
# SECTION
foo=hi
EOF
}

@test "update with empty pre line and line" {
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --pre-update '' --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar

$UPDATE
# SECTION
foo=hi
EOF
}

@test "update with single space pre line and line" {
    PRELINE=' '
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
$UPDATE
# SECTION
foo=hi
EOF
}
