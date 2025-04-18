#!/usr/bin/env bats

load temp

@test "update of file containing only the identical block returns 99" {
    run -99 updateBlock --marker test --block-text "$TEXT" "${BATS_TEST_DIRNAME}/only-block.txt"
    assert_output - < "${BATS_TEST_DIRNAME}/only-block.txt"
}

@test "in-place update of file containing only the identical block returns 99" {
    cp "${BATS_TEST_DIRNAME}/only-block.txt" "$NONE"
    run -99 updateBlock --in-place --marker test --block-text "$TEXT" "$NONE"
    assert_output ''
    diff -y "${BATS_TEST_DIRNAME}/only-block.txt" "$NONE"
}

@test "update of file with the identical block ending on the add-before line returns 99" {
    run -99 updateBlock --marker test --block-text 'Final testing' --add-before 4 "$FILE4"
    assert_output - < "$LAST"
}

@test "in-place update of file with the identical block ending on the add-before line returns 99" {
    run -99 updateBlock --in-place --marker test --block-text 'Final testing' --add-before 4 "$FILE4"
    assert_output ''
    diff -y "$LAST" "$FILE4"
}

@test "update of file containing only a different block updates it" {
    run -0 updateBlock --marker test --block-text new-stuff "${BATS_TEST_DIRNAME}/only-block.txt"
    assert_output - <<'EOF'
# BEGIN test
new-stuff
# END test
EOF
}

@test "update of file containing only a block with a different marker returns 1" {
    run -1 updateBlock --marker different --block-text new-stuff "${BATS_TEST_DIRNAME}/only-block.txt"
    assert_output - < "${BATS_TEST_DIRNAME}/only-block.txt"
}
