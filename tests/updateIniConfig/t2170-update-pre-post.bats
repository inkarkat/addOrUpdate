#!/usr/bin/env bats

load temp

@test "update with pre and post line to existing default configuration" {
    PRELINE='# new config start'
    POSTLINE='# new config end'
    run -0 updateIniConfig --pre-update "$PRELINE" --post-update "$POSTLINE" --section default --key foo --value new "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
$PRELINE
foo=new
$POSTLINE
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}
