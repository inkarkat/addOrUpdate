#!/usr/bin/env bats

load temp

@test "returns 1 and error message if the file does not have a block with that marker" {
    run -1 containedOrUpdateBlock --in-place --marker nowhereToBeFound --block-text "Single line" "$FILE2"
    assert_output "$FILE2 does not have nowhereToBeFound; no update possible."
}

@test "returns 99 and error message if the file already contains the block" {
    run -99 containedOrUpdateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2"
    assert_output "$FILE2 already contains subsequent; no update necessary."
}
