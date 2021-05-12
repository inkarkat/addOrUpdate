#!/usr/bin/env bats

load temp

@test "patching not-writable existing file returns 4" {
    chmod -w -- "$FILE"
    [ ! -w "$FILE" ]
    run containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 4 ]
    [ "$output" = "" ]
}
