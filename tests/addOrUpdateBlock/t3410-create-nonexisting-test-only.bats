#!/usr/bin/env bats

load fixture

@test "test-only update with nonexisting file does not create it" {
    run -0 addOrUpdateBlock --test-only --create-nonexisting --marker test --block-text "$TEXT" "$NONE"
    assert_output ''
    assert_not_exists "$NONE"
}

@test "test-only update with all nonexisting files creates none" {
    run -0 addOrUpdateBlock --test-only --create-nonexisting --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "test-only update with nonexisting first file does not create it" {
    run -0 addOrUpdateBlock --test-only --create-nonexisting --marker test --block-text "$TEXT" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "test-only update with nonexisting files and --all creates and appends each" {
    run -0 addOrUpdateBlock --test-only --create-nonexisting --all --marker test --block-text "$TEXT" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
