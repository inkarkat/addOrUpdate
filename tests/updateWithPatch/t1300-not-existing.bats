#!/usr/bin/env bats

load temp

@test "patching non-existing file returns 1" {
    run -1 updateWithPatch doesNotExist.patch
    assert_output "patch: **** Can't open patch file doesNotExist.patch : No such file or directory"
}
