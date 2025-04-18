#!/usr/bin/env bats

load temp

@test "asks with custom command name" {
    init
    NAME="My test file"
    export MEMOIZEDECISION_CHOICE=n
    run containedOrAddOrUpdateAssignment --name "$NAME" --in-place --lhs foo --rhs new "$FILE"
    assert_output -p "${NAME} does not yet contain 'foo=new'. Shall I update it?"
}
