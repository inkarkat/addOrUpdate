#!/usr/bin/env bats

load temp

@test "update with nonexisting line inserts before the first match of ADDRESSes only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-before '/^foo=/;/z/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
}
