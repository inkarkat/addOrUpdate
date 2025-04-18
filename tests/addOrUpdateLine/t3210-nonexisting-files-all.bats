#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --all --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<EOF
sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y - --label expected "$FILE2" <<EOF
$UPDATE
quux=initial
foo=moo bar baz
EOF
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting all files returns 4" {
    UPDATE='foo=new'
    run -4 addOrUpdateLine --all --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
