#!/usr/bin/env bats

load temp

@test "update all in first file also updates or appends in following files" {
    addOrUpdateBlock --all --in-place --marker test --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
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

@test "update all with match in second file appends to previous and following files" {
    addOrUpdateBlock --all --in-place --marker 'final and empty' --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
    [ "$(cat "$FILE3")" = "# BEGIN test
The same stuff
here again.
# END test
# BEGIN final and empty
single-line
# END final and empty" ]
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
    [ "$(cat "$FILE4")" = "one
# BEGIN test
Final testing
# END test
middle
# BEGIN subsequent
Single line
# END subsequent
end
# BEGIN final and empty
single-line
# END final and empty" ]
}

@test "update all with existing block in all files keeps contents and returns 99" {
    run addOrUpdateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4"
    [ $status -eq 99 ]
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE4" "$LAST"
}

@test "update all with existing block in first two files updates at the end of the last file only" {
    addOrUpdateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4" "$FILE3"
    cmp "$FILE2" "$EXISTING"
    cmp "$FILE4" "$LAST"
    [ "$(cat "$FILE3")" = "$(cat "$ANOTHER")
# BEGIN subsequent
Single line
# END subsequent" ]
}

@test "update all with existing block in two files updates at the end of the other two files only" {
    run addOrUpdateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE" "$FILE2" "$FILE3" "$FILE4"
    [ "$(cat "$FILE")" = "$(cat "$FRESH")
# BEGIN subsequent
Single line
# END subsequent" ]
    cmp "$FILE2" "$EXISTING"
    [ "$(cat "$FILE3")" = "$(cat "$ANOTHER")
# BEGIN subsequent
Single line
# END subsequent" ]
    cmp "$FILE4" "$LAST"
}

@test "update all with nonexisting block appends at the end of all files" {
    addOrUpdateBlock --all --in-place --marker 'totally new' --block-text "$TEXT" "$FILE2" "$FILE3" "$FILE4"
    [ "$(cat "$FILE2")" = "$(cat "$EXISTING")
# BEGIN totally new
single-line
# END totally new" ]
    [ "$(cat "$FILE3")" = "$(cat "$ANOTHER")
# BEGIN totally new
single-line
# END totally new" ]
    [ "$(cat "$FILE4")" = "$(cat "$LAST")
# BEGIN totally new
single-line
# END totally new" ]
}
