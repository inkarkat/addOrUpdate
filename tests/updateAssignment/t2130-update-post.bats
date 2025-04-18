#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment skips post line and returns 1" {
    POSTLINE='# new footer'
    run -1 updateAssignment --post-update "$POSTLINE" --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}

@test "update with one post line and assignment" {
    POSTLINE='# new footer'
    run -0 updateAssignment --post-update "$POSTLINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=new
$POSTLINE
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

