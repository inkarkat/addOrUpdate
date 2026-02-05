#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 99" {
    run -99 updateIniConfig --all --in-place --section default --key foo --value bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing assignment in first file returns 1" {
    run -1 updateIniConfig --all --in-place --section global --key bar --value hey "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing assignment in one file returns 1" {
    run -1 updateIniConfig --all --in-place --section global --key bar --value hey "$FILE2" "$FILE3" "$FILE"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with nonexisting assignment returns 1" {
    run -1 updateIniConfig --all --in-place --section default --key new --value add "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}
