#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    UPDATE='foo=new'
    run -0 updateLine --ignore-nonexisting --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "passing just nonexisting files succeeds with --all" {
    UPDATE='foo=new'
    run -0 updateLine --all --ignore-nonexisting --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
