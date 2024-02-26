#!/usr/bin/env bats

load temp

@test "patching a patched file fails with 99 and skipping error, and keeps the original intact" {
    cp -f "$RESULT" "$FILE"
    run containedOrUpdateWithPatch "$PATCH"
    [ $status -eq 99 ]
    [ "$output" = "existing.txt already contains diff.patch; no update necessary." ]
    cmp "$RESULT" "$FILE"
}
