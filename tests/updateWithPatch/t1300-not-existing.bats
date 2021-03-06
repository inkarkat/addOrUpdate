#!/usr/bin/env bats

load temp

@test "patching non-existing file returns 5" {
    run updateWithPatch doesNotExist.patch
    [ $status -eq 5 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}
