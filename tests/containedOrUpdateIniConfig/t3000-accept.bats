#!/usr/bin/env bats

load temp

@test "asks, updates, and returns 0 if the update is accepted by the user" {
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateIniConfig --in-place --section default --key foo --value new "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=new
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}
