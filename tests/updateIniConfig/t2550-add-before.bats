#!/usr/bin/env bats

load temp

@test "update with updated default configuration on the passed line updates that line" {
    run -0 updateIniConfig --add-before 7 --section default --key foo --value boo "$FILE"
    assert_output - <<'EOF'
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=boo
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}

@test "update with existing configuration one after the passed line keeps contents and returns 1" {
    run -1 updateIniConfig --add-before 6 --section default --key foo --value bar "$FILE"
    diff -y "$INPUT" "$FILE"
}
