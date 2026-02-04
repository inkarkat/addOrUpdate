#!/usr/bin/env bats

load temp

@test "error when no section, key and value passed" {
    run -2 addOrUpdateIniConfig "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no default passed" {
    run -2 addOrUpdateIniConfig --key foo --value "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no key passed" {
    run -2 addOrUpdateIniConfig --section default --value bar "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no value passed" {
    run -2 addOrUpdateIniConfig --section default --key foo "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --in-place and --test-only" {
    run -2 addOrUpdateIniConfig --in-place --test-only --section default --key foo --value new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --in-place and --test-only.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 addOrUpdateIniConfig --ignore-nonexisting --create-nonexisting --section default --key foo --value new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}
