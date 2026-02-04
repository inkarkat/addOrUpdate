#!/usr/bin/env bats

load temp

@test "update with post line to nonexisting default configuration appends at the end" {
    POSTLINE='# new config'
    run -0 addOrUpdateIniConfig --post-line "$POSTLINE" --section default --key add --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
add=new
$POSTLINE

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with three separate post lines to nonexisting default configuration appends at the end" {
    POSTLINE1='# first header'
    POSTLINE2=''
    POSTLINE3='# third header'
    run -0 addOrUpdateIniConfig --post-line "$POSTLINE1" --post-line "$POSTLINE2" --post-line "$POSTLINE3" --section default --key add --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
add=new
$POSTLINE1
$POSTLINE2
$POSTLINE3

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with post line to existing default configuration ignores post line" {
    POSTLINE='# new config'
    run -0 addOrUpdateIniConfig --post-line "$POSTLINE" --section default --key foo --value new "$FILE"
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

@test "update with post line, nonexisting section and configuration appends section and config at the end" {
    POSTLINE='# new config'
    run -0 addOrUpdateIniConfig --post-line "$POSTLINE" --section new-section --key add --value new "$FILE"
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
$POSTLINE
EOF
}
