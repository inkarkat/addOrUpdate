#!/usr/bin/env bats

load temp

@test "update with existing marker and different block before empty line" {
    run -0 updateBlock --marker subsequent --block-text "$TEXT" --add-before '/^$/' "$FILE2"
    assert_output - <<EOF
first line
second line
third line
# BEGIN test
The original comment
is this one.
# END test
# BEGIN subsequent
$TEXT
# END subsequent

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
# END final and empty
last line
EOF
}

@test "update with existing block before an empty line keeps contents and returns 99" {
    run -99 updateBlock --marker subsequent --block-text "Single line" --add-before '/^$/' "$FILE2"
    assert_output - < "$EXISTING"
}

@test "update with existing marker and same multi-line block after the passed line keeps contents and returns 99" {
    run -99 updateBlock --marker test --block-text $'The original comment\nis this one.' --add-before 12 "$FILE2"
    assert_output - < "$EXISTING"
}
