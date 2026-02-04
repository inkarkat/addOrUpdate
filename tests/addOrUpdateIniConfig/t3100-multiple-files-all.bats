#!/usr/bin/env bats

load temp

@test "update all with existing assignment in all files keeps contents and returns 99" {
    run -99 addOrUpdateIniConfig --all --in-place --section default --key foo --value bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update all with existing assignment in first file appends at the end of the other files" {
    addOrUpdateIniConfig --all --in-place --section global --key bar --value hey "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<EOF
[global]
bar=hey

[default]
foo=bar
quux=initial
foo=moo bar baz
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")

[global]
bar=hey
EOF
}

@test "update all with existing assignment in one file appends at the end of the two other files only" {
    addOrUpdateIniConfig --all --in-place --section global --key bar --value hey "$FILE2" "$FILE3" "$FILE"
    diff -y - --label expected "$FILE2" <<EOF
[global]
bar=hey

[default]
foo=bar
quux=initial
foo=moo bar baz
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")

[global]
bar=hey
EOF
    diff -y "$FILE" "$INPUT"
}

@test "update all with nonexisting assignment appends to all files" {
    addOrUpdateIniConfig --all --in-place --section default --key new --value add "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<EOF
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=bar
foo=hoo bar baz
new=add

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
    diff -y - --label expected "$FILE2" <<EOF
$(cat "$MORE2")
new=add
EOF
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
new=add
EOF
}
