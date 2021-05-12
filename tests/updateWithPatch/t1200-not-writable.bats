#!/usr/bin/env bats

load temp

@test "patching not-writable existing file returns 4" {
    chmod -w -- "$FILE"
    [ ! -w "$FILE" ]
    run updateWithPatch --in-place "$PATCH"
    [ $status -eq 4 ]
    [ "$output" = "File existing.txt is read-only; refusing to patch
1 out of 1 hunk ignored" ]
}
