#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern appends multi-line at the end" {
    UPDATE=$'foo=multi\nline'
    run -0 addOrUpdateLine --line "$UPDATE" --update-match "foosball=never" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with literal-like pattern updates first matching line with multiple lines" {
    UPDATE=$'foo=multi\nline'
    run -0 addOrUpdateLine --line "$UPDATE" --update-match "foo=h" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
# SECTION
foo=hi
EOF
}
