#!/usr/bin/env bats

load temp

@test "asks with custom command name" {
    NAME='My test file'
    export MEMOIZEDECISION_CHOICE=n
    run containedOrAddOrUpdateBlock --name "$NAME" --marker test --block-text new "$FILE2"
    assert_output -p "${NAME} does not yet contain test. Shall I update it?"
}
