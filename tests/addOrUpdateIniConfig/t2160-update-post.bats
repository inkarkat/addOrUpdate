#!/usr/bin/env bats

load temp

@test "update with post line to nonexisting default configuration ignores post line" {
    POSTLINE='# new config'
    run -0 addOrUpdateIniConfig --post-update "$POSTLINE" --section default --key add --value new "$FILE"
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

@test "update with three separate post lines to existing default configuration" {
    POSTLINE1='# first header'
    POSTLINE2=''
    POSTLINE3='# third header'
    run -0 addOrUpdateIniConfig --post-update "$POSTLINE1" --post-update "$POSTLINE2" --post-update "$POSTLINE3" --section default --key foo --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=new
$POSTLINE1
$POSTLINE2
$POSTLINE3
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with post line to existing default configuration" {
    POSTLINE='# new config'
    run -0 addOrUpdateIniConfig --post-update "$POSTLINE" --section default --key foo --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=new
$POSTLINE
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with post line, nonexisting section and configuration appends section ignores post line" {
    POSTLINE='# new config'
    run -0 addOrUpdateIniConfig --post-update "$POSTLINE" --section new-section --key add --value new "$FILE"
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
