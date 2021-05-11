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

@test "patching with custom patch arguments" {
    run updateWithPatch -p0 --unified --follow-symlinks -El "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}
