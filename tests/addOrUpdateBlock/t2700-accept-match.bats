#!/usr/bin/env bats

load temp

@test "update with existing marker but nonmatching accept pattern updates the block" {
    run addOrUpdateBlock --marker test --accept-match doesNotMatch --block-text "$TEXT" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "first line
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
}

@test "update with existing marker and literal-like matching accept pattern keeps contents and returns 99" {
    run addOrUpdateBlock --marker test --accept-match third --block-text "$TEXT" "$FILE2"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$EXISTING")" ]
}

@test "update with existing marker and accept pattern that matches too late updates the block" {
    run addOrUpdateBlock --marker test --accept-match middle --block-text "$TEXT" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "first line
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
}

@test "update with existing marker and anchored matching accept pattern keeps contents and returns 99" {
    run addOrUpdateBlock --marker test --accept-match '^\(second\|third\) line$' --block-text "$TEXT" "$FILE2"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$EXISTING")" ]
}
