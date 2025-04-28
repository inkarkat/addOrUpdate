#!/usr/bin/env bats

load temp

@test "in-place update with nonexisting default configuration appends at the end" {
    run -0 addOrUpdateIniConfig --in-place --section default --key add --value new "$FILE"
    assert_output ''
    diff -y - --label expected "$FILE" <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
add=new

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "in-place update with existing default configuration keeps contents and returns 99" {
    run -99 addOrUpdateIniConfig --in-place --section default --key foo --value bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with nonexisting default configuration succeeds" {
    run -0 addOrUpdateIniConfig --test-only --section default --key add --value new "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing default configuration returns 99" {
    run -99 addOrUpdateIniConfig --test-only --section default --key foo --value bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
