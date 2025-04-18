#!/usr/bin/env bats

load temp

@test "asks, appends, and returns 0 if the update is accepted by the user" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE"
    assert_output -p 'does not yet contain test. Shall I update it?'
    diff -y - --label expected "$FILE" <<EOF
$(cat "$FRESH")
$BLOCK
EOF
}

@test "asks, updates, and returns 0 if the update is accepted by the user" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE3"
    assert_output -p 'does not yet contain test. Shall I update it?'
    assert_equal "$(<"$FILE3")" "$BLOCK"
}
