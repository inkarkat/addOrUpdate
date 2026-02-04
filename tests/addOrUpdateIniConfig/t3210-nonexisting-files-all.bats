#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run -0 addOrUpdateIniConfig --all --in-place --section default --key foo --value new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
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
    diff -y - --label expected "$FILE2" <<'EOF'
[global]

[default]
foo=new
quux=initial
foo=moo bar baz
EOF
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting all files returns 4" {
    run -4 addOrUpdateIniConfig --all --in-place --section default --key foo --value new "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
