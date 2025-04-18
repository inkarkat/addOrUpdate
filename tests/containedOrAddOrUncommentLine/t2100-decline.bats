#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUncommentLine --in-place --line new "$FILE"
    assert_output -p "does not yet contain 'new'. Shall I update it?"
}
