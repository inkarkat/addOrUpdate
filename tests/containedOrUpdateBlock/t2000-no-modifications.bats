#!/usr/bin/env bats

load temp

@test "returns 1 and error message if the file already contains the block" {
    run containedOrUpdateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 1 ]
    [ "$output" = "$FILE2 already contains subsequent; no update necessary." ]
}
