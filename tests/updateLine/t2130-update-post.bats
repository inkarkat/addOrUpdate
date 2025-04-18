#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips post line and returns 1" {
    POSTLINE='# new footer'
    run -1 updateLine --post-update "$POSTLINE" --update-match "foosball=never" --replacement '&&' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with one post line and line" {
    POSTLINE='# new footer'
    UPDATE='foo=not here'
    run -0 updateLine --post-update "$POSTLINE" --update-match "foo=h.*" --line "$UPDATE" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE
# SECTION
foo=hi
EOF
}

