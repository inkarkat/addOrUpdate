#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrUpdateWithPatch --in-place "$PATCH"
    assert_output -p 'existing.txt does not yet contain diff.patch. Shall I apply it?'
}
