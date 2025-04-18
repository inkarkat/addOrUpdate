#!/usr/bin/env bats

load temp

@test "error when no SED-ARGS passed" {
    run -2 addOrUpdateWithSed -- "$FILE"
    assert_line -n 0 'ERROR: No SED-ARGS passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --in-place and --test-only" {
    run -2 addOrUpdateWithSed --in-place --test-only $SED_UPDATE -- "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --in-place and --test-only.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 addOrUpdateWithSed --ignore-nonexisting --create-nonexisting $SED_UPDATE -- "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}
