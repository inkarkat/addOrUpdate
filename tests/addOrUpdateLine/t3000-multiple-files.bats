#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    UPDATE='foo=new'
    addOrUpdateLine --in-place --line "$UPDATE" --update-match "foo=bar" "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<EOF
sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    UPDATE='quux=updated'
    addOrUpdateLine --in-place --line "$UPDATE" --update-match "quux=" "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<EOF
foo=bar
$UPDATE
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing line in all files keeps contents and returns 99" {
    run -99 addOrUpdateLine --in-place --line "foo=bar" "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing line in first file appends at the end of the last file only" {
    UPDATE='foo=hoo bar baz'
    addOrUpdateLine --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
$UPDATE
EOF
}

@test "update with nonexisting line appends at the end of the last file only" {
    UPDATE='foo=new'
    addOrUpdateLine --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
$UPDATE
EOF
}
