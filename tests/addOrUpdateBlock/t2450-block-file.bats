#!/usr/bin/env bats

load temp

@test "update with nonexisting marker and multi-line block from file appends the block" {
    run -0 addOrUpdateBlock --marker test --block-file "${BATS_TEST_DIRNAME}/block.txt" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
# BEGIN test
$(cat "${BATS_TEST_DIRNAME}/block.txt")
# END test
EOF
}

@test "update with existing marker and two blocks from files updates the block" {
    run -0 addOrUpdateBlock --marker test --block-file "${BATS_TEST_DIRNAME}/block.txt" --block-file "${BATS_TEST_DIRNAME}/block2.txt" "$FILE2"
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

@test "update with nonexisting marker and multiple blocks from file and text appends the block" {
    run -0 addOrUpdateBlock --marker test --block-text "Leading line" --block-file "${BATS_TEST_DIRNAME}/block.txt" --block-text "Trailing line" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
# BEGIN test
Leading line
$(cat "${BATS_TEST_DIRNAME}/block.txt")
Trailing line
# END test
EOF
}
