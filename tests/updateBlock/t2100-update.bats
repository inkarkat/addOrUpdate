#!/usr/bin/env bats

load temp

@test "update with nonexisting marker returns 1" {
    run updateBlock --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$FRESH")" ]
}

@test "update with existing marker and same single-line block keeps contents and returns 99" {
    run updateBlock --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$EXISTING")" ]
}

@test "update with existing marker and different single-line block updates the block" {
    run updateBlock --marker subsequent --block-text "Changed line" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "first line
second line
third line
# BEGIN test
The original comment
is this one.
# END test
# BEGIN subsequent
Changed line
# END subsequent

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
# END final and empty
last line" ]
}

@test "update with existing marker and same multi-line block keeps contents and returns 99" {
    run updateBlock --marker test --block-text $'The original comment\nis this one.' "$FILE2"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$EXISTING")" ]
}

@test "update with existing marker and different multi-line block updates the block" {
    run updateBlock --marker test --block-text $'across\nmultiple\nlines' "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "first line
second line
third line
# BEGIN test
across
multiple
lines
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
}
