#!/usr/bin/env bats

load temp

@test "test-only update with nonexisting file does not create it" {
    run -0 addOrUpdateWithSed --test-only --create-nonexisting $SED_UPDATE -- "$NONE"
    assert_output ''
    assert_not_exists "$NONE"
}

@test "test-only update with all nonexisting files creates none" {
    run -0 addOrUpdateWithSed --test-only --create-nonexisting $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "test-only update with nonexisting first file does not create it" {
    run -0 addOrUpdateWithSed --test-only --create-nonexisting $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "test-only update with nonexisting files and --all creates none" {
    run -0 addOrUpdateWithSed --test-only --create-nonexisting --all $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
