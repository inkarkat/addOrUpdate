#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    addOrUpdateIniConfig --in-place --section default --key foo --value new "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<'EOF'
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=new
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    addOrUpdateIniConfig --in-place --section default --key quux --value new "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
[global]

[default]
foo=bar
quux=new
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing assignment in all files keeps contents and returns 99" {
    run -99 addOrUpdateIniConfig --section default --in-place --key foo --value bar "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing assignment in first file keeps contents and returns 99" {
    run -99 addOrUpdateIniConfig --in-place --section global --key bar --value hey "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with nonexisting assignment appends at the end of the last file only" {
    addOrUpdateIniConfig --in-place --section default --key new --value add "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y - --label expected "$FILE3" <<EOF
$(cat "$MORE3")
new=add
EOF
}
