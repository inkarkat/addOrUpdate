#!/usr/bin/env bats

load temp

@test "patching non-existing file returns 1" {
    run updateWithPatch doesNotExist.patch
    [ $status -eq 1 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}
