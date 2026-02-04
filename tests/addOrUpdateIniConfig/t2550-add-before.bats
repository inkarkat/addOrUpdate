#!/usr/bin/env bats

load temp

@test "update with nonexisting default configuration inserts before the passed match" {
    run -0 addOrUpdateIniConfig --add-before '/^foo=/' --section default --key add --value new "$FILE"
    assert_output - <<'EOF'
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
add=new
foo=bar
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with nonexisting section appends at the end" {
    run -0 addOrUpdateIniConfig --add-before '/^foo=/' --section new-section --key add --value new "$FILE"
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

[new-section]
add=new
EOF
}
