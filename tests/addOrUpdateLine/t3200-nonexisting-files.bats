#!/usr/bin/env bats

load temp

@test "processing standard input works" {
    CONTENTS='# useless'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS
$UPDATE
EOF
}

@test "nonexisting file and standard input works" {
    CONTENTS='# useless'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" "$NONE" - <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS
$UPDATE
EOF
}

@test "update in first existing file skips nonexisting files" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$FILE" "$NONE2" "$FILE2"
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
    run -4 addOrUpdateLine --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
