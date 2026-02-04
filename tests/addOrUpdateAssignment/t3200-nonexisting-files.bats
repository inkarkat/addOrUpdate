#!/usr/bin/env bats

load temp

@test "processing standard input works" {
    CONTENTS="# useless"
    run -0 addOrUpdateAssignment --lhs new --rhs add <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS
new=add
EOF
}

@test "nonexisting file and standard input works" {
    CONTENTS="# useless"
    run -0 addOrUpdateAssignment --lhs new --rhs add "$NONE" - <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS
new=add
EOF
}

@test "update in first existing file skips nonexisting files" {
    run -0 addOrUpdateAssignment --in-place --lhs foo --rhs add "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
foo=add
foo=hoo bar baz
# SECTION
fox=hi
EOF
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    run -4 addOrUpdateAssignment --in-place --lhs new --rhs add "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
