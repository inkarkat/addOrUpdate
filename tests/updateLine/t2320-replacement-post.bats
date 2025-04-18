#!/usr/bin/env bats

load temp

@test "update with pattern matching full line uses post line and LINE" {
    POSTLINE='# new footer'
    run -0 updateLine --post-update "$POSTLINE" --update-match '^foo=h.*$' --line "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
ox=replaced
$POSTLINE
# SECTION
foo=hi
EOF
}

@test "update with pattern matching partial line uses post line and REPLACEMENT just for match" {
    POSTLINE='# new footer'
    run -0 updateLine --post-update "$POSTLINE" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
fox=replaced bar baz
$POSTLINE
# SECTION
foo=hi
EOF
}
