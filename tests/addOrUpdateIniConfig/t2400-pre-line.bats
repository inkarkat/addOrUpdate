#!/usr/bin/env bats

load temp

@test "update with pre line to nonexisting default configuration appends at the end" {
    PRELINE='# new config'
    run -0 addOrUpdateIniConfig --pre-line "$PRELINE" --section default --key add --value new "$FILE"
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

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with three separate pre lines to nonexisting default configuration appends at the end" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateIniConfig --pre-line "$PRELINE1" --pre-line "$PRELINE2" --pre-line "$PRELINE3" --section default --key add --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
$PRELINE1
$PRELINE2
$PRELINE3
add=new

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with pre line to existing default configuration ignores pre line" {
    PRELINE='# new config'
    run -0 addOrUpdateIniConfig --pre-line "$PRELINE" --section default --key foo --value new "$FILE"
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

@test "update with pre line, nonexisting section and configuration appends section and config at the end" {
    PRELINE='# new config'
    run -0 addOrUpdateIniConfig --pre-line "$PRELINE" --section new-section --key add --value new "$FILE"
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
EOF
}
