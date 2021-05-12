#!/usr/bin/env bats

load temp

@test "patching a patched file fails with 1 and skipping error, and keeps the original intact" {
    cp -f "$RESULT" "$FILE"
    run updateWithPatch "$PATCH"
    [ $status -eq 1 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
    cmp "$RESULT" "$FILE"
}
