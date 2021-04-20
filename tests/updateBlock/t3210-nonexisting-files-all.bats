#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run updateBlock --all --in-place --marker test --block-text "$TEXT" "$NONE" "$FILE3" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE3")" = "# BEGIN test
$TEXT
# END test" ]
    [ "$(cat "$FILE2")" = "first line
second line
third line
# BEGIN test
$TEXT
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
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "all nonexisting all files returns 4" {
    run updateBlock --all --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
