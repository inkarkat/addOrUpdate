#!/usr/bin/env bats

load temp

@test "update with pre line to nonexisting default configuration ignores pre line" {
    PRELINE='# new config'
    run -0 addOrUpdateIniConfig --pre-update "$PRELINE" --section default --key add --value new "$FILE"
    assert_output - <<EOF
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

@test "update with three separate pre lines to existing default configuration" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateIniConfig --pre-update "$PRELINE1" --pre-update "$PRELINE2" --pre-update "$PRELINE3" --section default --key foo --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
$PRELINE1
$PRELINE2
$PRELINE3
foo=new
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with pre line to existing default configuration" {
    PRELINE='# new config'
    run -0 addOrUpdateIniConfig --pre-update "$PRELINE" --section default --key foo --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
$PRELINE
foo=new
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with pre line, nonexisting section and configuration appends section ignores pre line" {
    PRELINE='# new config'
    run -0 addOrUpdateIniConfig --pre-update "$PRELINE" --section new-section --key add --value new "$FILE"
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

[new-section]
add=new
EOF
}
