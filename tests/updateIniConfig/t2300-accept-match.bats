#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern returns 1" {
    run -1 updateIniConfig --section default --key new --value add --accept-match "foosball=never" "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "update with literal-like pattern keeps contents and returns 99" {
    run -99 updateIniConfig --section default --key foo --value new --accept-match "foo=b" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with anchored pattern keeps contents and returns 99" {
    run -99 updateIniConfig --section default --key foo --value new --accept-match "^fo\+=[abc].*$" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with pattern containing forward and backslash keeps contents and returns 99" {
    run -99 updateIniConfig --section default --key foo --value '/e\' --accept-match "^.*/.=.*\\.*" "$FILE"
    assert_output - < "$INPUT"
}
