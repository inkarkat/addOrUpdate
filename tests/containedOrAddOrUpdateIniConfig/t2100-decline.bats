#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateIniConfig --in-place --section default --key foo --value new "$FILE"
    assert_output -p "does not yet contain 'foo=new'. Shall I update it?"
}
