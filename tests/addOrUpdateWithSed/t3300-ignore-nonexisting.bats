#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    run -0 addOrUpdateWithSed --ignore-nonexisting --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "passing just nonexisting files succeeds with --all" {
    run -0 addOrUpdateWithSed --all --ignore-nonexisting --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
