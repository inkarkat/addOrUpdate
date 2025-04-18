#!/usr/bin/env bats

load temp

@test "asks, patches, and returns 0 if the patch is accepted by the user" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateWithPatch --in-place "$PATCH"
    assert_output -p 'existing.txt does not yet contain diff.patch. Shall I apply it?'
    diff -y "$RESULT" "$FILE"
}

@test "asks about empty patch from null device" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateWithPatch --in-place /dev/null
    assert_output -p '??? does not yet contain null. Shall I apply it?'
}
