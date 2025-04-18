#!/usr/bin/env bats

load temp

@test "returns 99 and error message and does not modify the file when testing if the file already is up-to-date" {
    cp -f "$RESULT" "$FILE"
    run -99 containedOrUpdateWithPatch --test-only --in-place "$PATCH"
    assert_output 'existing.txt already contains diff.patch; no update necessary.'
    diff -y "$RESULT" "$FILE"
}

@test "returns 0 and message and does not modify the file when testing if the file needs the patch" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateWithPatch --test-only --in-place "$PATCH"
    assert_output 'existing.txt does not contain diff.patch; update required.'
    diff -y "$EXISTING" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs the patch" {
    NAME='My test file'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateWithPatch --test-only --in-place --name "$NAME" "$PATCH"
    assert_output "$NAME does not contain diff.patch; update required."
}

@test "returns 0 and no message with an empty one provided when testing if the file needs the patch" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateWithPatch --needs-update-message '' --test-only --in-place "$PATCH"
    assert_output ''
}

@test "returns 0 and a custom passed message when testing if the file needs the patch" {
    MESSAGE='The file needs the new.'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateWithPatch --needs-update-message "$MESSAGE" --test-only --in-place "$PATCH"
    assert_output "$MESSAGE"
}
