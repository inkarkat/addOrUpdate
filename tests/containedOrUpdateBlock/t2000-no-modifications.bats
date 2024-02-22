#!/usr/bin/env bats

load temp

@test "returns 1 and error message if the file does not have a block with that marker" {
    run containedOrUpdateBlock --in-place --marker nowhereToBeFound --block-text "Single line" "$FILE2"
    [ $status -eq 1 ]
    [ "$output" = "$FILE2 does not have nowhereToBeFound; no update possible." ]
}

@test "returns 98 and error message if the file already contains the block" {
    run containedOrUpdateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 98 ]
    [ "$output" = "$FILE2 already contains subsequent; no update necessary." ]
}
