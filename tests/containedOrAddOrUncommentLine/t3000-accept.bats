#!/usr/bin/env bats

load temp

@test "asks, appends, and returns 0 if the update is accepted by the user" {
    UPDATE='new'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "asks, updates, and returns 0 if the update is accepted by the user" {
    UPDATE='disabled'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
# line
line
disabled
# SECTION
some data
last
# last
EOF
}
