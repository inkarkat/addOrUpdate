#!/usr/bin/env bats

@test "update of block with customized comment prefix" {
    ADDORUPDATEBLOCK_COMMENT_PREFIX=// run updateBlock --marker test --block-text $'Updated stuff\n# END test' "${BATS_TEST_DIRNAME}/different-comment-prefix.txt"
    [ $status -eq 0 ]
    [ "$output" = "first
# BEGIN test
//BEGIN test
Updated stuff
# END test
//END test
BEGIN test
END test" ]
}

@test "update of block with customized no comment prefix" {
    ADDORUPDATEBLOCK_COMMENT_PREFIX= run updateBlock --marker test --block-text 'Updated stuff' "${BATS_TEST_DIRNAME}/different-comment-prefix.txt"
    [ $status -eq 0 ]
    [ "$output" = "first
# BEGIN test
//BEGIN test
The same stuff
here again.
# END test
//END test
BEGIN test
Updated stuff
END test" ]
}
