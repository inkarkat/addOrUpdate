#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
}
