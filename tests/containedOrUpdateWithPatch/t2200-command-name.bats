#!/usr/bin/env bats

load temp

@test "asks with custom command name" {
    NAME='My test file'
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrUpdateWithPatch --name "$NAME" --in-place "$PATCH"
    assert_output -p "${NAME} does not yet contain diff.patch. Shall I apply it?"
}
