#!/usr/bin/env bats

load temp

@test "update in first existing file skips nonexisting files" {
    run -0 updateIniConfig --in-place --section default --key foo --value add "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=add
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    run -4 updateIniConfig --in-place --section default --key new --value add "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
