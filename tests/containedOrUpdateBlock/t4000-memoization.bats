#!/usr/bin/env bats

load temp

@test "recalls positive choice on yes" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateBlock --memoize-group containedOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE2"
    assert_output -p "$(basename "$FILE2") does not yet contain test. Shall I update it?"

    cp -f "$EXISTING" "$FILE2"  # Restore original file.
    MEMOIZEDECISION_CHOICE=
    run -0 containedOrUpdateBlock --memoize-group containedOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE2"
    assert_output -p "$(basename "$FILE2") does not yet contain test. Will update it now."
}
