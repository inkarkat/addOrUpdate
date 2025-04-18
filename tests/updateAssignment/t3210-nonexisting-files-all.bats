#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run -0 updateAssignment --all --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
foo=new
quux=initial
foo=moo bar baz
EOF
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting all files returns 4" {
    run -4 updateAssignment --all --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
