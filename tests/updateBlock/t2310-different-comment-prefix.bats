#!/usr/bin/env bats

load fixture

@test "update of block with customized comment prefix" {
    ADDORUPDATEBLOCK_COMMENT_PREFIX=// run -0 updateBlock --marker test --block-text $'Updated stuff\n# END test' "${BATS_TEST_DIRNAME}/different-comment-prefix.txt"
    assert_output - <<'EOF'
first
# BEGIN test
//BEGIN test
Updated stuff
# END test
//END test
BEGIN test
END test
EOF
}

@test "update of block with customized no comment prefix" {
    ADDORUPDATEBLOCK_COMMENT_PREFIX= run -0 updateBlock --marker test --block-text 'Updated stuff' "${BATS_TEST_DIRNAME}/different-comment-prefix.txt"
    assert_output - <<'EOF'
first
# BEGIN test
//BEGIN test
The same stuff
here again.
# END test
//END test
BEGIN test
Updated stuff
END test
EOF
}

@test "update of block with customized comment prefix and suffix" {
    ADDORUPDATEBLOCK_COMMENT_PREFIX='<!-- ' ADDORUPDATEBLOCK_COMMENT_SUFFIX=' -->' \
	run -0 updateBlock --marker test --block-text $'Updated stuff\n# END test' "${BATS_TEST_DIRNAME}/different-comment-prefix-suffix.txt"
    assert_output - <<'EOF'
first
# BEGIN test
<!-- BEGIN test -->
Updated stuff
# END test
<!-- END test -->
BEGIN test
END test
EOF
}
