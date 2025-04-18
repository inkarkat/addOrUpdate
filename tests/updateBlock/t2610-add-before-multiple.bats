#!/usr/bin/env bats

load temp

@test "update with existing marker after the passed line skips early to do the update in the second file and ignores the existing later marker" {
    run -0 updateBlock --in-place --marker test --block-text "$TEXT" --add-before 6 "$FILE2" "$FILE3"
    diff -y "$FILE2" "$EXISTING"
    assert_equal "$(<"$FILE3")" "$BLOCK"
}
