#!/usr/bin/env bats

load temp

@test "update in first existing file skips nonexisting files" {
    run -0 updateBlock --in-place --marker test --block-text "$TEXT" "$NONE" "$FILE3" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE3" <<EOF
# BEGIN test
$TEXT
# END test
EOF
    diff -y "$FILE2" "$EXISTING"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    run -4 updateBlock --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
