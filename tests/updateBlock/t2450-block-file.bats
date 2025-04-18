#!/usr/bin/env bats

load temp

@test "update with existing marker and two blocks from files updates the block" {
    run -0 updateBlock --marker test --block-file "${BATS_TEST_DIRNAME}/block.txt" --block-file "${BATS_TEST_DIRNAME}/block2.txt" "$FILE2"
    assert_output - <<EOF
first line
second line
third line
# BEGIN test
$(cat "${BATS_TEST_DIRNAME}/block.txt" "${BATS_TEST_DIRNAME}/block2.txt")
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
}
