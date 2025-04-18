#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips post line and appends at the end" {
    POSTLINE='# new footer'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foosball=never" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with one post line and line" {
    POSTLINE='# new footer'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE
# SECTION
foo=hi
EOF
}

@test "identical update skips post line" {
    POSTLINE='# new footer'
    run -99 addOrUpdateLine --line 'foo=new' --post-update "$POSTLINE" --update-match '^foo=b.*' --replacement 'foo=bar' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with three separate post lines and line" {
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --post-update "$POSTLINE1" --post-update "$POSTLINE2" --post-update "$POSTLINE3" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE1
$POSTLINE2
$POSTLINE3
# SECTION
foo=hi
EOF
}

@test "update with one multi-line post line and line" {
    POSTLINE='# first footer

# third footer'
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE1
$POSTLINE2
$POSTLINE3
# SECTION
foo=hi
EOF
}

@test "update with empty post line and line" {
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --post-update '' --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE

# SECTION
foo=hi
EOF
}

@test "update with single space post line and line" {
    POSTLINE=' '
    UPDATE='foo=not here'
    run -0 addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE
# SECTION
foo=hi
EOF
}
