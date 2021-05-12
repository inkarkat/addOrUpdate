#!/usr/bin/env bats

load temp

@test "in-place patching with backup extension updates the file and writes backup" {
    run updateWithPatch --in-place=.bak "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$RESULT"
    cmp "$EXISTING" "${FILE}.bak"
}
