#!/usr/bin/env bats

load temp

@test "patching non-existing file returns 5" {
    run updateWithPatch --in-place doesNotExist.patch
    [ $status -eq 5 ]
    [ "$output" = "ERROR: Patch does not exist: doesNotExist.patch" ]
}
