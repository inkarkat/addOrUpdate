#!/usr/bin/env bats

load temp

@test "asks with custom command name" {
    NAME='My test file'
    export MEMOIZEDECISION_CHOICE=n
    run containedOrAddOrUncommentLine --name "$NAME" --in-place --line new "$FILE"
    assert_output -p "${NAME} does not yet contain 'new'. Shall I update it?"
}
