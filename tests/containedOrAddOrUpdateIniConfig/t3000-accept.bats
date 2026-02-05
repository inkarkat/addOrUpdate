#!/usr/bin/env bats

load temp

@test "asks, appends, and returns 0 if the update is accepted by the user" {
    UPDATE="new=add"
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateIniConfig --in-place --section default --key new --value add "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
new=add

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "asks, updates, and returns 0 if the update is accepted by the user" {
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateIniConfig --in-place --section default --key foo --value new "$FILE"
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

@test "asks, appends, and returns 0 if the section + addition is accepted by the user" {
    SECTION_UPDATE="new-section"
    UPDATE="new=add"
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateIniConfig --in-place --section "$SECTION_UPDATE" --key new --value add "$FILE"
    assert_output -p "does not yet contain '[${SECTION_UPDATE}]'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old

[new-section]
new=add
EOF
}
