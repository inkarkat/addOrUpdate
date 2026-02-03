#!/usr/bin/env bats

load temp

@test "update with nonexisting line appends after the first match of ADDRESSes only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-after '/^foo=/;/z/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi
EOF
}
