#!/usr/bin/env bats

load temp

@test "update all updates all files" {
    UPDATE='foo=new'
    addOrUpdateLine --all --in-place --line "$UPDATE" --update-match "foo=bar" "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<EOF
sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y - --label expected "$FILE2" <<EOF
$UPDATE
quux=initial
foo=moo bar baz
EOF
    diff -y - --label expected "$FILE3" <<EOF
zulu=here
$UPDATE
foo=no bar baz
EOF
}

@test "update all with match in second file appends to previous and following files" {
    UPDATE='quux=updated'
    addOrUpdateLine --all --in-place --line "$UPDATE" --update-match "quux=" "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
$UPDATE
EOF
    diff -y - --label expected "$FILE2" <<EOF
foo=bar
$UPDATE
foo=moo bar baz
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
$UPDATE
EOF
}

@test "update all with existing line in all files keeps contents and returns 99" {
    run -99 addOrUpdateLine --all --in-place --line "foo=bar" "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing line in first file appends at the end of the other files" {
    UPDATE='foo=hoo bar baz'
    addOrUpdateLine --all --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<EOF
$(cat "$MORE2")
$UPDATE
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
$UPDATE
EOF
}

@test "update all with existing line in one file appends at the end of the two other files only" {
    UPDATE='foo=hoo bar baz'
    addOrUpdateLine --all --in-place --line "$UPDATE" "$FILE2" "$FILE3" "$FILE"
    diff -y - --label expected "$FILE2" <<EOF
$(cat "$MORE2")
$UPDATE
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
$UPDATE
EOF
    diff -y "$FILE" "$INPUT"
}

@test "update all with nonexisting line appends to all files" {
    UPDATE='foo=new'
    addOrUpdateLine --all --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
$UPDATE
EOF
    diff -y - --label expected "$FILE2" <<EOF
$(cat "$MORE2")
$UPDATE
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
$UPDATE
EOF
}
