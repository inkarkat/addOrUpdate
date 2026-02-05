#!/usr/bin/env bats

load temp

@test "in-place update with nonexisting default configuration returns 1" {
    run -1 updateIniConfig --in-place --section default --key add --value new "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "in-place update with existing default configuration keeps contents and returns 99" {
    run -99 updateIniConfig --in-place --section default --key foo --value bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with nonexisting default configuration returns 1" {
    run -1 updateIniConfig --test-only --section default --key add --value new "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing default configuration returns 99" {
    run -99 updateIniConfig --test-only --section default --key foo --value bar "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
