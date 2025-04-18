#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    init
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateAssignment --in-place --lhs foo --rhs new "$FILE"
    assert_output -p "does not yet contain 'foo=new'. Shall I update it?"
}
