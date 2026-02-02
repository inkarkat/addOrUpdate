#!/usr/bin/env bats

load temp

@test "update with nonexisting line inserts on the first match of before and after ADDRESSes only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-before '/^#/' --add-after '/^foo=/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with nonexisting line inserts on the first match of after and before ADDRESSes only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-before '/^foo=/' --add-after '/^#/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$UPDATE
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with nonexisting line inserts as the last given parameter if both before and after ADDRESSes are identical" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-after '/^#/' --add-before '/^#/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi
EOF
}
