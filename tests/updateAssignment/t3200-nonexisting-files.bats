#!/usr/bin/env bats

load temp

@test "update in first existing file skips nonexisting files" {
    run -0 updateAssignment --in-place --lhs new --rhs add --update-match "foo=bar" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
new=add
foo=hoo bar baz
# SECTION
fox=hi
EOF
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    run -4 updateAssignment --in-place --lhs new --rhs add --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
