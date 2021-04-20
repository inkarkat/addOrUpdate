#!/usr/bin/env bats

load temp

@test "update all in first file also updates or appends in following files" {
    updateBlock --all --in-place --marker test --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
    [ "$(cat "$FILE3")" = "# BEGIN test
single-line
# END test" ]
    [ "$(cat "$FILE2")" = "first line
second line
third line
# BEGIN test
single-line
# END test
# BEGIN subsequent
Single line
# END subsequent

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
# END final and empty
last line" ]
    [ "$(cat "$FILE4")" = "one
# BEGIN test
single-line
# END test
middle
# BEGIN subsequent
Single line
# END subsequent
end" ]
}

@test "update all with match in second file keeps previous and following files" {
    updateBlock --all --in-place --marker 'final and empty' --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
    cmp "$FILE3" "$ANOTHER"
    [ "$(cat "$FILE2")" = "first line
second line
third line
# BEGIN test
The original comment
is this one.
# END test
# BEGIN subsequent
Single line
# END subsequent

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
single-line
# END final and empty
last line" ]
    cmp "$FILE4" "$LAST"
}

@test "update all with existing block in all files keeps contents and returns 1" {
    run updateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4"
    [ $status -eq 1 ]
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE4" "$LAST"
}

@test "update all with existing block in first two files returns 1" {
    run updateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE3" "$ANOTHER"
    cmp "$FILE4" "$LAST"
}

@test "update all with existing block in two files returns 1" {
    run updateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE" "$FILE2" "$FILE3" "$FILE4"
    [ $status -eq 1 ]
    cmp "$FILE" "$FRESH"
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE3" "$ANOTHER"
    cmp "$FILE4" "$LAST"
}

@test "update all with nonexisting block returns 1" {
    run updateBlock --all --in-place --marker 'totally new' --block-text "$TEXT" "$FILE2" "$FILE3" "$FILE4"
    [ $status -eq 1 ]
    cmp "$FILE" "$FRESH"
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE3" "$ANOTHER"
    cmp "$FILE4" "$LAST"
}
