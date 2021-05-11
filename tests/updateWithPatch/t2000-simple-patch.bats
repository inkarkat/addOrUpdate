#!/usr/bin/env bats

load temp

@test "in-place patching updates the file" {
    run updateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "new first line
first line
augmented second line
third line
last line" ]
}
