#!/usr/bin/env bats

load temp

@test "in-place patching with backup extension updates the file and writes backup" {
    run -0 updateWithPatch --in-place=.bak "$PATCH"
    assert_output ''
    diff -y "$FILE" "$RESULT"
    diff -y "$EXISTING" "${FILE}.bak"
}
