#!/usr/bin/env bats

load temp

@test "error when no section, key and value passed" {
    run -2 containedOrUpdateIniConfig "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no default passed" {
    run -2 containedOrUpdateIniConfig --key foo --value "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no key passed" {
    run -2 containedOrUpdateIniConfig --section default --value bar "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no value passed" {
    run -2 containedOrUpdateIniConfig --section default --key foo "$FILE"
    assert_line -n 0 'ERROR: All of -s|--section SECTION, -k|--key KEY and -v|--value VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 containedOrUpdateIniConfig --ignore-nonexisting --create-nonexisting --section default --key foo --value new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}
