#!/usr/bin/env bats

load temp

@test "message with multiple files" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE" "$FILE2" "$FILE3"
    assert_output -e 'At least one of .* does not yet contain test\. Shall I update it\?'
}

@test "--all message with multiple files" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateBlock --all --in-place --marker test --block-text "$TEXT" "$FILE" "$FILE2" "$FILE3"
    assert_output -e 'All of .* do not yet contain test\. Shall I update them\?'
}
