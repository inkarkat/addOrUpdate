#!/usr/bin/env bats

load temp

@test "reverse patch fails with 1 and skipping error, and keeps the original intact" {
    run updateWithPatch "$REVERTED_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
    cmp "$EXISTING" "$FILE"
}

@test "reversed patching prints the result and keeps the original intact" {
    run updateWithPatch --reverse "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place reversed patching updates the file" {
    run updateWithPatch --in-place --reverse "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$RESULT"
}
