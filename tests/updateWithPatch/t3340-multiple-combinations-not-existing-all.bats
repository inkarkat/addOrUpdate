#!/usr/bin/env bats

load temp

@test "patching all with success and non-existing file returns 1" {
    run updateWithPatch --all --test-only "$PATCH" doesNotExist.patch
    [ $status -eq 1 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching all with non-existing and success returns 1" {
    run updateWithPatch --all --test-only doesNotExist.patch "$PATCH"
    [ $status -eq 1 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching all with non-existing and non-applicable returns 1" {
    run updateWithPatch --all --test-only doesNotExist.patch "$UNAPPLICABLE_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory
1 out of 1 hunk FAILED" ]
}

@test "patching all with non-applicable and non-existing returns 1" {
    run updateWithPatch --all --test-only "$UNAPPLICABLE_PATCH" doesNotExist.patch
    [ $status -eq 1 ]
    [ "$output" = "1 out of 1 hunk FAILED
patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching all with no-mod and non-existing returns 1" {
    run updateWithPatch --all --test-only "$REVERTED_PATCH" doesNotExist.patch
    [ $status -eq 1 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching all with non-existing and no-mod returns 1" {
    run updateWithPatch --all --test-only doesNotExist.patch "$REVERTED_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}
