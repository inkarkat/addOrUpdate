#!/usr/bin/env bats

load temp

@test "update with existing marker after the passed line skips early to do the update in the second file and ignores the existing later marker" {
    run addOrUpdateBlock --in-place --marker test --block-text "$TEXT" --add-before 6 "$FILE2" "$FILE3"
    [ $status -eq 0 ]
    cmp "$FILE2" "$EXISTING"
    [ "$(cat "$FILE3")" = "$BLOCK" ]
}
