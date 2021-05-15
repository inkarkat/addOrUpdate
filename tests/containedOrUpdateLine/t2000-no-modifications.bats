#!/usr/bin/env bats

load temp

@test "returns 1 and error message if the file already contains the line" {
    init
    run containedOrUpdateLine --in-place --update-match "foo=bar" --replacement "foo=bar" "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$FILE already contains 'foo=bar'; no update necessary." ]
}
