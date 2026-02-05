#!/usr/bin/env bats

load temp

@test "does not modify the file if the file already contains the assignment" {
    run containedOrAddOrUpdateIniConfig --in-place --section default --key foo --value bar "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "returns 99 and error message if the file already contains the assignment" {
    run -99 containedOrAddOrUpdateIniConfig --in-place --section default --key foo --value bar "$FILE"
    assert_output "$FILE already contains 'foo=bar'; no update necessary."
}

@test "returns 99 and error message mentioning the name if the file already contains the assignment" {
    NAME="My test file"
    run -99 containedOrAddOrUpdateIniConfig --in-place --name "$NAME" --section default --key foo --value bar "$FILE"
    assert_output "$NAME already contains 'foo=bar'; no update necessary."
}

@test "returns 99 and no error message with an empty one passed if the file already contains the assignment" {
    run -99 containedOrAddOrUpdateIniConfig --up-to-date-message '' --in-place --section default --key foo --value bar "$FILE"
    assert_output ''
}

@test "returns 99 and a custom passed message if the file already contains the assignment" {
    MESSAGE='The file already has the bar.'
    run -99 containedOrAddOrUpdateIniConfig --up-to-date-message "$MESSAGE" --in-place --section default --key foo --value bar "$FILE"
    assert_output "$MESSAGE"
}

@test "returns 4 if none of the passed files exist" {
    run -4 containedOrAddOrUpdateIniConfig --in-place --section default --key foo --value bar "$NONE" "$NONE2"
    assert_output ''
}
