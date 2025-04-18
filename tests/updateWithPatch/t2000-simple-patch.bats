#!/usr/bin/env bats

load temp

@test "patching prints the result and keeps the original intact" {
    run -0 updateWithPatch "$PATCH"
    assert_output - < "$RESULT"
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching updates the file" {
    run -0 updateWithPatch --in-place "$PATCH"
    assert_output ''
    diff -y "$FILE" "$RESULT"
}

@test "patching with custom patch arguments" {
    run -0 updateWithPatch -p0 --unified --follow-symlinks -El "$PATCH"
    assert_output - < "$RESULT"
    diff -y "$EXISTING" "$FILE"
}
