#!/usr/bin/env bats

load temp

@test "returns 99 and error message and does not modify the file when testing if the file already contains the line" {
    run -99 containedOrAddOrUncommentLine --test-only --in-place --line 'some data' "$FILE"
    assert_output "$FILE already contains 'some data'; no update necessary."
    diff -y "$INPUT" "$FILE"
}

@test "returns 0 and message and does not modify the file when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --test-only --in-place --line disabled "$FILE"
    assert_output "$FILE does not contain 'disabled'; update required."
    diff -y "$INPUT" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs an update" {
    NAME='My test file'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --test-only --in-place --name "$NAME" --line disabled "$FILE"
    assert_output "$NAME does not contain 'disabled'; update required."
}

@test "returns 0 and no message with an empty one provided when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --needs-update-message '' --test-only --in-place --line disabled "$FILE"
    assert_output ''
}

@test "returns 0 and a custom passed message when testing if the file needs an update" {
    MESSAGE='The file needs the disabled.'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --needs-update-message "$MESSAGE" --test-only --in-place --line disabled "$FILE"
    assert_output "$MESSAGE"
}
