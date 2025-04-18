#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips pre line and returns 1" {
    PRELINE='# new header'
    run -1 updateAssignment --pre-update "$PRELINE" --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}

@test "update with one pre line and assignment" {
    PRELINE='# new header'
    run -0 updateAssignment --pre-update "$PRELINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$PRELINE
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

