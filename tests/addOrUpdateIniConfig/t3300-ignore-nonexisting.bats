#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    run -0 addOrUpdateIniConfig --ignore-nonexisting --in-place --section default --key foo --value new "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "passing just nonexisting files succeeds with --all" {
    run -0 addOrUpdateIniConfig --all --ignore-nonexisting --in-place --section default --key foo --value new "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
