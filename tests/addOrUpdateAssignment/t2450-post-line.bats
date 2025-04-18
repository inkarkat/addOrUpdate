#!/usr/bin/env bats

load temp

@test "append with one post line" {
    POSTLINE='# new footer'
    run -0 addOrUpdateAssignment --post-line "$POSTLINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
$POSTLINE
EOF
}

@test "append with three separate post lines" {
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    run -0 addOrUpdateAssignment --post-line "$POSTLINE1" --post-line "$POSTLINE2" --post-line "$POSTLINE3" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
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
    run -0 addOrUpdateAssignment --post-line "$POSTLINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
$POSTLINE1
$POSTLINE2
$POSTLINE3
EOF
}

addOrUpdateLineWithPeriod()
{
    addOrUpdateAssignment "$@"; printf .
}
@test "empty post line" {
    run -0 addOrUpdateLineWithPeriod --post-line '' --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add

.
EOF
}

@test "single space post line" {
    POSTLINE=' '
    run -0 addOrUpdateLineWithPeriod --post-line "$POSTLINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
${POSTLINE}
.
EOF
}
