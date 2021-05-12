#!/usr/bin/env bats

load temp

@test "patching with success and non-existing file returns 5" {
    run updateWithPatch --test-only "$PATCH" doesNotExist.patch
    [ $status -eq 5 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching with non-existing and success returns 5" {
    run updateWithPatch --test-only doesNotExist.patch "$PATCH"
    [ $status -eq 5 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching with non-existing and non-applicable returns 5" {
    run updateWithPatch --test-only doesNotExist.patch "$UNAPPLICABLE_PATCH"
    [ $status -eq 5 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory
1 out of 1 hunk FAILED" ]
}

@test "patching with non-applicable and non-existing returns 5" {
    run updateWithPatch --test-only "$UNAPPLICABLE_PATCH" doesNotExist.patch
    [ $status -eq 5 ]
    [ "$output" = "1 out of 1 hunk FAILED
patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching with no-mod and non-existing returns 5" {
    run updateWithPatch --test-only "$REVERTED_PATCH" doesNotExist.patch
    [ $status -eq 5 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
patch: **** Can't open patch file doesNotExist.patch : No such file or directory" ]
}

@test "patching with non-existing and no-mod returns 5" {
    run updateWithPatch --test-only doesNotExist.patch "$REVERTED_PATCH"
    [ $status -eq 5 ]
    [ "$output" = "patch: **** Can't open patch file doesNotExist.patch : No such file or directory
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}
