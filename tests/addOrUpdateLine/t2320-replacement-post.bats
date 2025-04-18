#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips post line and appends LINE not REPLACEMENT at the end" {
    POSTLINE='# new footer'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foosball=never" --replacement "not=used" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with pattern matching full line uses post line and REPLACEMENT" {
    POSTLINE='# new footer'
    run -0 addOrUpdateLine --post-update "$POSTLINE" --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
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
    run -0 addOrUpdateLine --post-update "$POSTLINE" --line "foo=new" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
fox=replaced bar baz
$POSTLINE
# SECTION
foo=hi
EOF
}
