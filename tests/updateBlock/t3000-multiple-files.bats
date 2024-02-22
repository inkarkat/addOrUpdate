#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    updateBlock --in-place --marker test --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
    [ "$(cat "$FILE3")" = "# BEGIN test
single-line
# END test" ]
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE4" "$LAST"
}

@test "update with match in second file skips previous and following files" {
    updateBlock --in-place --marker subsequent --block-text "$TEXT" "$FILE3" "$FILE4" "$FILE2"
    cmp "$FILE3" "$ANOTHER"
    [ "$(cat "$FILE4")" = "one
# BEGIN test
Final testing
# END test
middle
# BEGIN subsequent
single-line
# END subsequent
end" ]
    cmp "$FILE2" "$EXISTING"
}

@test "update with existing block in all files keeps contents and returns 99" {
    run updateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4"
    [ $status -eq 99 ]
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE4" "$LAST"
}

@test "update with existing block in first two files returns 1" {
    run updateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE3" "$ANOTHER"
    cmp "$FILE4" "$LAST"
}

@test "update with nonexisting block appends at the end of the last file only" {
    run updateBlock --in-place --marker 'totally new' --block-text "$TEXT" "$FILE2" "$FILE3" "$FILE4"
    [ $status -eq 1 ]
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE3" "$ANOTHER"
    cmp "$FILE4" "$LAST"
}
