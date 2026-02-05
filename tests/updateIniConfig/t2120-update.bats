#!/usr/bin/env bats

load temp

@test "update with existing last configuration replaces config" {
    run -0 updateIniConfig --section 'last one' --key foo --value new "$FILE"
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
foo=new
EOF
}

@test "update with existing configuration in section containing forward and backslash replaces config" {
    run -0 updateIniConfig --section 'spec/ial\one' --key foo --value new "$FILE"
    assert_output - <<'EOF'
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz

[spec/ial\one]
foo=new

[last one]
foo=old
EOF
}

@test "update with existing default configuration replaces first occurring config" {
    run -0 updateIniConfig --section 'default' --key foo --value new "$FILE"
    assert_output - <<'EOF'
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

@test "update with existing global configuration in first section replaces first occurring config" {
    run -0 updateIniConfig --section 'global' --key foo --value new "$FILE"
    assert_output - <<'EOF'
[global]
foo=new
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
}
