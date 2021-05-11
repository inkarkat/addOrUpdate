#!/usr/bin/env bats

load temp

@test "patching prints the result and keeps the original intact" {
    run updateWithPatch "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching updates the file" {
    run updateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$RESULT"
}
