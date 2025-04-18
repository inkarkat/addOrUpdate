#!/usr/bin/env bats

load temp

@test "asks, appends, and returns 0 if the update is accepted by the user" {
    init
    UPDATE="new=add"
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateAssignment --in-place --lhs new --rhs add "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "asks, updates, and returns 0 if the update is accepted by the user" {
    init
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateAssignment --in-place --lhs foo --rhs new "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
