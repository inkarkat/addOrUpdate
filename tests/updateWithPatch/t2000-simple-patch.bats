#!/usr/bin/env bats

load temp

@test "patching prints the result and keeps the original intact" {
    run updateWithPatch "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "new first line
first line
augmented second line
third line
last line" ]
    cmp "$EXISTING" "$FILE"
}

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
