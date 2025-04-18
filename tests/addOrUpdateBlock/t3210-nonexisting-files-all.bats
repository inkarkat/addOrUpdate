#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run -0 addOrUpdateBlock --all --in-place --marker test --block-text "$TEXT" "$NONE" "$FILE3" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE3" <<EOF
# BEGIN test
$TEXT
# END test
EOF
    diff -y - --label expected "$FILE2" <<EOF
first line
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
last line
EOF
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting all files returns 4" {
    run -4 addOrUpdateBlock --all --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
