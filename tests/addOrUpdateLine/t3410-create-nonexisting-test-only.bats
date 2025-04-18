#!/usr/bin/env bats

load fixture

@test "test-only update with nonexisting file does not create it" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --test-only --create-nonexisting --line "$UPDATE" --update-match "foo=bar" "$NONE"
    assert_output ''
    assert_not_exists "$NONE"
}

@test "test-only update with all nonexisting files creates none" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --test-only --create-nonexisting --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "test-only update with nonexisting first file does not create it" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --test-only --create-nonexisting --line "$UPDATE" --update-match "foo=bar" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "test-only update with nonexisting files and --all creates none" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --test-only --create-nonexisting --all --line "$UPDATE" --update-match "foo=bar" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
