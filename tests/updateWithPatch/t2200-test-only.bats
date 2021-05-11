#!/usr/bin/env bats

load temp

@test "test-only reverse patch fails with 4 and skipping error, and keeps the original intact" {
    run updateWithPatch --test-only "$REVERTED_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
    cmp "$EXISTING" "$FILE"
}

@test "test-only patching does not print a result and keeps the original intact" {
    run updateWithPatch --test-only "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}
