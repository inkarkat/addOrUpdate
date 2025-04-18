#!/usr/bin/env bats

load temp

@test "returns 1 and error message if the file does not match" {
    run -1 containedOrUpdateLine --in-place --update-match nowhereToBeFound --replacement "foo=bar" "$FILE"
    assert_output "$FILE does not match; no update possible."
}

@test "returns 99 and error message if the file already contains the line" {
    run -99 containedOrUpdateLine --in-place --update-match "foo=bar" --replacement "foo=bar" "$FILE"
    assert_output "$FILE already contains 'foo=bar'; no update necessary."
}
