#!/usr/bin/env bats

load temp

@test "update in first existing file skips nonexisting files" {
    run -0 appendAssignment --in-place --lhs foo --rhs add "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
sing/e="wha\ever"
foo="bar add"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    run -4 appendAssignment --in-place --lhs new --rhs add --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
