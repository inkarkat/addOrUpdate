#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern appends at the end of the default section" {
    run -0 addOrUpdateIniConfig --section default --key new --value add --accept-match "foosball=never" "$FILE"
    assert_output - <<EOF
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

@test "update with literal-like pattern keeps contents and returns 99" {
    run -99 addOrUpdateIniConfig --section default --key foo --value new --accept-match "foo=b" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with anchored pattern keeps contents and returns 99" {
    run -99 addOrUpdateIniConfig --section default --key foo --value new --accept-match "^fo\+=[abc].*$" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with pattern containing forward and backslash keeps contents and returns 99" {
    run -99 addOrUpdateIniConfig --section default --key foo --value '/e\' --accept-match "^.*/.=.*\\.*" "$FILE"
    assert_output - < "$INPUT"
}
