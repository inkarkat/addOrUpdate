#!/usr/bin/env bats

load temp

@test "update with existing default configuration keeps contents and returns 99" {
    run -99 updateIniConfig --section default --key foo --value bar "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing default configuration containing forward and backslash keeps contents and returns 99" {
    run -99 updateIniConfig --section default --key 'sing/e' --value 'wha\ever' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing configuration in section containing forward and backslash keeps contents and returns 99" {
    run -99 updateIniConfig --section 'spec/ial\one' --key 'foo' --value 'hi' "$FILE"
    assert_output - < "$INPUT"
}
