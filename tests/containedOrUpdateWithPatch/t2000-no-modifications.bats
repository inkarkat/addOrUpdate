#!/usr/bin/env bats

load temp

@test "patching a patched file fails with 99 and skipping error, and keeps the original intact" {
    cp -f "$RESULT" "$FILE"
    run -99 containedOrUpdateWithPatch "$PATCH"
    assert_output 'existing.txt already contains diff.patch; no update necessary.'
    diff -y "$RESULT" "$FILE"
}
