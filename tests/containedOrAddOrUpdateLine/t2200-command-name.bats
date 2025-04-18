#!/usr/bin/env bats

load temp

@test "asks with custom command name" {
    NAME='My test file'
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=n
    run containedOrAddOrUpdateLine --name "$NAME" --in-place --line "$UPDATE" "$FILE"
    assert_output -p "${NAME} does not yet contain '$UPDATE'. Shall I update it?"
}
