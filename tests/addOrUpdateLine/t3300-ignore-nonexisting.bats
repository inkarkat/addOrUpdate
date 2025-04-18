#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --ignore-nonexisting --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "passing just nonexisting files succeeds with --all" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --all --ignore-nonexisting --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
