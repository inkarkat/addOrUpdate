#!/usr/bin/env bats

load temp

@test "append with one post line" {
    POSTLINE='# new footer'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --post-line "$POSTLINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
$POSTLINE
EOF
}

@test "append with three separate post lines" {
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    UPDATE="foo=new"
    run -0 addOrUpdateLine --post-line "$POSTLINE1" --post-line "$POSTLINE2" --post-line "$POSTLINE3" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
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
    UPDATE='foo=new'
    run -0 addOrUpdateLine --post-line "$POSTLINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
$POSTLINE1
$POSTLINE2
$POSTLINE3
EOF
}

addOrUpdateLineWithPeriod()
{
    addOrUpdateLine "$@"; printf .
}

@test "empty post line" {
    UPDATE='foo=new'
    run -0 addOrUpdateLineWithPeriod --post-line '' --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE

.
EOF
}

@test "empty and non-empty post lines" {
    UPDATE='foo=new'
    run -0 addOrUpdateLineWithPeriod --post-line '' --post-line "$POSTLINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE

$POSTLINE
.
EOF
}

@test "non-empty and empty post lines" {
    UPDATE='foo=new'
    run -0 addOrUpdateLineWithPeriod --post-line "$POSTLINE" --post-line '' --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
$POSTLINE

.
EOF
}

@test "single space post line" {
    POSTLINE=' '
    UPDATE='foo=new'
    run -0 addOrUpdateLineWithPeriod --post-line "$POSTLINE" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
${POSTLINE}
.
EOF
}
