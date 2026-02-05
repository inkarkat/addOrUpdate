#!/usr/bin/env bats

load temp

@test "update with pre line to nonexisting default configuration skips pre line and returns 1" {
    PRELINE='# new config'
    run -1 updateIniConfig --pre-update "$PRELINE" --section default --key add --value new "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "update with three separate pre lines to existing default configuration" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 updateIniConfig --pre-update "$PRELINE1" --pre-update "$PRELINE2" --pre-update "$PRELINE3" --section default --key foo --value new "$FILE"
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
    run -0 updateIniConfig --pre-update "$PRELINE" --section default --key foo --value new "$FILE"
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

@test "update with pre line, nonexisting section and configuration skips pre line and returns 1" {
    PRELINE='# new config'
    run -1 updateIniConfig --pre-update "$PRELINE" --section new-section --key add --value new "$FILE"
    diff -y "$FILE" "$INPUT"
}
