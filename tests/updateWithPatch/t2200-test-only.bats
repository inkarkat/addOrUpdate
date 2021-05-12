#!/usr/bin/env bats

load temp

@test "test-only reverse patch fails with 1 and skipping error, and keeps the original intact" {
    run updateWithPatch --test-only "$REVERTED_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
    cmp "$EXISTING" "$FILE"
}

@test "test-only non-applicable patch fails with 4 and skipping error, and keeps the original intact" {
    run updateWithPatch --test-only "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$EXISTING" "$FILE"
}

@test "test-only patching does not print a result and keeps the original intact" {
    run updateWithPatch --test-only "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}
