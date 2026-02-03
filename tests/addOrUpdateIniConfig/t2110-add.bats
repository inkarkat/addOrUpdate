#!/usr/bin/env bats

load temp

@test "update with nonexisting default configuration appends at the end" {
    run -0 addOrUpdateIniConfig --section default --key add --value new "$FILE"
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

@test "update with nonexisting default configuration containing forward and backslash appends at the end" {
    run -0 addOrUpdateIniConfig --section default --key '/new\' --value '\here/' "$FILE"
    assert_output - <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
/new\=\here/

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with nonexisting configuration in last section appends at the very end" {
    run -0 addOrUpdateIniConfig --section 'last one' --key 'add' --value 'new' "$FILE"
    assert_output - <<'EOF'
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
add=new
EOF
}
