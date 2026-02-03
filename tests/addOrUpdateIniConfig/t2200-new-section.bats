#!/usr/bin/env bats

load temp

@test "update with nonexisting section and configuration appends section and config at the end" {
    run -0 addOrUpdateIniConfig --section new-section --key add --value new "$FILE"
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

@test "update with nonexisting section but configuration in another section appends section and config at the end" {
    run -0 addOrUpdateIniConfig --section new-section --key foo --value bar "$FILE"
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
foo=bar
EOF
}

@test "update of header-only file adds section and config" {
    EMPTY="${BATS_TMPDIR}/empty.ini"
    echo '# Just a header' > "$EMPTY"
    run -0 addOrUpdateIniConfig --section new-section --key add --value new "$EMPTY"
    assert_output - <<'EOF'
# Just a header

[new-section]
add=new
EOF
}
