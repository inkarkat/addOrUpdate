#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    run -0 addOrUpdateBlock --ignore-nonexisting --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "passing just nonexisting files succeeds with --all" {
    run -0 addOrUpdateBlock --all --ignore-nonexisting --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
