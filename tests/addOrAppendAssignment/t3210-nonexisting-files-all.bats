#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run -0 addOrAppendAssignment --all --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
sing/e="wha\ever"
foo="bar new"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
foo="bar new"
quux="initial value"
fox=
foy=""
EOF
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting all files returns 4" {
    run -4 addOrAppendAssignment --all --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
