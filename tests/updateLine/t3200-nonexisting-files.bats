#!/usr/bin/env bats

load temp

@test "update in first existing file skips nonexisting files" {
    UPDATE='foo=new'
    run -0 updateLine --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<EOF
sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    UPDATE='foo=new'
    run -4 updateLine --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
