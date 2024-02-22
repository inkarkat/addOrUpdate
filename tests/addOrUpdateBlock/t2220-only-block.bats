#!/usr/bin/env bats

load temp

@test "update of file containing only the identical block returns 99" {
    run addOrUpdateBlock --marker test --block-text "$TEXT" "${BATS_TEST_DIRNAME}/only-block.txt"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "${BATS_TEST_DIRNAME}/only-block.txt")" ]
}

@test "in-place update of file containing only the identical block returns 99" {
    cp "${BATS_TEST_DIRNAME}/only-block.txt" "$NONE"
    run addOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$NONE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "${BATS_TEST_DIRNAME}/only-block.txt" "$NONE"
}

@test "update of file with the identical block ending on the add-before line returns 99" {
    run addOrUpdateBlock --marker test --block-text 'Final testing' --add-before 4 "$FILE4"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$LAST")" ]
}

@test "in-place update of file with the identical block ending on the add-before line returns 99" {
    run addOrUpdateBlock --in-place --marker test --block-text 'Final testing' --add-before 4 "$FILE4"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$LAST" "$FILE4"
}

@test "update of file containing only a different block updates it" {
    run addOrUpdateBlock --marker test --block-text new-stuff "${BATS_TEST_DIRNAME}/only-block.txt"
    [ $status -eq 0 ]
    [ "$output" = "# BEGIN test
new-stuff
# END test" ]
}

@test "update of file containing only a block with a different marker appends the block" {
    run addOrUpdateBlock --marker different --block-text new-stuff "${BATS_TEST_DIRNAME}/only-block.txt"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "${BATS_TEST_DIRNAME}/only-block.txt")
# BEGIN different
new-stuff
# END different" ]
}
