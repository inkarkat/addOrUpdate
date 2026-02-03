#!/usr/bin/env bats

load temp

@test "update with pre and post line to nonexisting default configuration appends at the end" {
    PRELINE='# new config start'
    POSTLINE='# new config end'
    run -0 addOrUpdateIniConfig --pre-line "$PRELINE" --post-line "$POSTLINE" --section default --key add --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
$PRELINE
add=new
$POSTLINE

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with pre and post line to existing default configuration ignores pre and post lines" {
    PRELINE='# new config start'
    POSTLINE='# new config end'
    run -0 addOrUpdateIniConfig --pre-line "$PRELINE" --post-line "$POSTLINE" --section default --key foo --value new "$FILE"
    assert_output - <<EOF
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

@test "update with pre and post line, nonexisting section and configuration appends section and config at the end" {
    PRELINE='# new config start'
    POSTLINE='# new config end'
    run -0 addOrUpdateIniConfig --pre-line "$PRELINE" --post-line "$POSTLINE" --section new-section --key add --value new "$FILE"
    assert_output - <<EOF
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

$PRELINE
[new-section]
add=new
$POSTLINE
EOF
}
