#!/usr/bin/env bats

load temp

@test "patching not-writable existing file returns 4" {
    export MEMOIZEDECISION_CHOICE=y
    chmod -w -- "$FILE"
    assert_not_file_permission -w "$FILE"
    run -4 containedOrUpdateWithPatch --in-place "$PATCH"
    assert_output -p 'existing.txt does not yet contain diff.patch. Shall I apply it?'
}
