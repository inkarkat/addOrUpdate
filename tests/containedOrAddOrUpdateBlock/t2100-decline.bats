#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateBlock --in-place --marker test --block-text new "$FILE2"
    assert_output -p 'does not yet contain test. Shall I update it?'
}
