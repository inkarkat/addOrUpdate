#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips pre line and returns 1" {
    PRELINE='# new header'
    run -1 updateLine --pre-update "$PRELINE" --update-match "foosball=never" --replacement '&&' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with one pre line and line" {
    PRELINE='# new header'
    UPDATE='foo=not here'
    run -0 updateLine --pre-update "$PRELINE" --update-match "foo=h.*" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
$UPDATE
# SECTION
foo=hi
EOF
}

