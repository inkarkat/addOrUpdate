#!/usr/bin/env bats

load temp

@test "update all updates all files" {
    UPDATE='foo=new'
    updateLine --all --in-place --update-match "foo=bar" --replacement "$UPDATE" "$FILE" "$FILE2" "$FILE3"
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

@test "update all with match in second file updates that file" {
    UPDATE='quux=updated'
    run -0 updateLine --all --in-place --update-match "quux=.*" --replacement "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    diff -y "$INPUT" "$FILE"
    diff -y - --label expected "$FILE2" <<EOF
foo=bar
$UPDATE
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing line in all files keeps contents and returns 99" {
    run -99 updateLine --all --in-place --update-match "foo=bar" --replacement '&' "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing line in first file returns 99" {
    UPDATE='foo=hoo bar baz'
    run -99 updateLine --all --in-place --update-match "$UPDATE" --replacement '&' "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing line in one file returns 99" {
    UPDATE='foo=hoo bar baz'
    run -99 updateLine --all --in-place --update-match "$UPDATE" --replacement '&' "$FILE2" "$FILE3" "$FILE"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with nonexisting line returns 1" {
    run -1 updateLine --all --in-place --update-match "foosball=never" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}
